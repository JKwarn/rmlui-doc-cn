---
layout: page
title: Search
include_in_search_results: false
---

<script src="{{ "/assets/scripts/lunr.js" | relative_url }}"></script>

<form style="text-align: center" id="form-search" class="form-search" action="" method="get">
  <input type="search" class="input-medium search-query" id="search-box" placeholder="Search..." name="q">
  <input type="submit" class="btn" value="Search">
</form>

---

<div id="search-results"></div>

<script>
function getQueryParam(variable) {
	var query = window.location.search.substring(1);
	var vars = query.split('&');

	for (var i = 0; i < vars.length; i++) {
		var pair = vars[i].split('=');

		if (pair[0] === variable) {
			return decodeURIComponent(pair[1].replace(/\+/g, '%20'));
		}
	}
	return '';
}

function setQueryParam(key, value, replace_state) {
	if (typeof(URLSearchParams) != "undefined" && history.pushState) {
		var params = new URLSearchParams(window.location.search);
		params.set(key, value);

		var newUrl =
			window.location.protocol +
			"//" +
			window.location.host +
			window.location.pathname +
			'?' +
			params.toString();

		var state_obj = {
			path: newUrl
		};

		if (replace_state)
			window.history.replaceState(state_obj, '', newUrl);
		else
			window.history.pushState(state_obj, '', newUrl);
	}
}


/*
 * --------------------------------------------------------------------------
 * Unified tokenizer
 * --------------------------------------------------------------------------
 *
 * Lunr 默认 tokenizer / trimmer 对 CJK 文本并不适合。
 *
 * 这里不修改 lunr.js，而是在 search.md 中定义自己的 tokenizer。
 *
 * CJK 文本：
 *
 *   "本地化"
 *
 * 会产生：
 *
 *   本地化
 *   本地
 *   地化
 *
 * 因此：
 *
 *   本地化  -> 可以命中
 *   本地    -> 可以命中
 *   地化    -> 可以命中
 *
 * 对连续中文文本还保留完整字符串 token，因此搜索完整短语时
 * 可以获得更高的相关性。
 *
 * ASCII / 数字 / 英文仍按照连续字符串处理。
 */

function isCjkCharacter(ch) {
	if (!ch)
		return false;

	var code = ch.charCodeAt(0);

	return (
		(code >= 0x3400 && code <= 0x4DBF) ||   // CJK Extension A
		(code >= 0x4E00 && code <= 0x9FFF) ||   // CJK Unified Ideographs
		(code >= 0xF900 && code <= 0xFAFF) ||   // CJK Compatibility Ideographs
		(code >= 0x3040 && code <= 0x309F) ||   // Hiragana
		(code >= 0x30A0 && code <= 0x30FF) ||   // Katakana
		(code >= 0xAC00 && code <= 0xD7AF)      // Hangul
	);
}

function isAsciiWordCharacter(ch) {
	if (!ch)
		return false;

	var code = ch.charCodeAt(0);

	return (
		(code >= 0x30 && code <= 0x39) ||   // 0-9
		(code >= 0x41 && code <= 0x5A) ||   // A-Z
		(code >= 0x61 && code <= 0x7A) ||   // a-z
		ch === '_' ||
		ch === '.' ||
		ch === '+' ||
		ch === '#'
	);
}


/*
 * 返回普通字符串 token。
 *
 * 每个 token：
 *
 *   {
 *       text:     token 文本
 *       start:    在原始字符串中的起始位置
 *       length:   token 长度
 *   }
 *
 * 位置必须保留，因为后面的 Lunr 搜索结果高亮依赖 metadata.position。
 */
function tokenizeText(text) {
	var result = [];

	if (!text)
		return result;

	var i = 0;

	while (i < text.length) {
		var ch = text.charAt(i);

		/*
		 * CJK
		 */
		if (isCjkCharacter(ch)) {
			var start = i;

			while (
				i < text.length &&
				isCjkCharacter(text.charAt(i))
			) {
				i++;
			}

			var cjkText = text.slice(start, i);

			/*
			 * 完整 CJK 连续文本。
			 *
			 * 例如：
			 *   本地化
			 */
			if (cjkText.length > 0) {
				result.push({
					text: cjkText,
					start: start,
					length: cjkText.length
				});
			}

			/*
			 * CJK bigram。
			 *
			 * 例如：
			 *
			 *   本地化
			 *
			 * -> 本地
			 * -> 地化
			 *
			 * 这样搜索任意连续中文片段都可以命中。
			 */
			if (cjkText.length >= 2) {
				for (var j = 0; j < cjkText.length - 1; j++) {
					result.push({
						text: cjkText.slice(j, j + 2),
						start: start + j,
						length: 2
					});
				}
			}

			/*
			 * 单字符中文也建立 token。
			 *
			 * 这样单字搜索仍然有效。
			 */
			if (cjkText.length === 1) {
				result.push({
					text: cjkText,
					start: start,
					length: 1
				});
			}

			continue;
		}

		/*
		 * ASCII / 数字 / 常见代码字符。
		 */
		if (isAsciiWordCharacter(ch)) {
			var asciiStart = i;

			while (
				i < text.length &&
				isAsciiWordCharacter(text.charAt(i))
			) {
				i++;
			}

			var asciiText = text.slice(asciiStart, i);

			if (asciiText.length > 0) {
				result.push({
					text: asciiText.toLowerCase(),
					start: asciiStart,
					length: asciiText.length
				});
			}

			continue;
		}

		/*
		 * 其它字符作为分隔符。
		 */
		i++;
	}

	return result;
}


/*
 * Lunr tokenizer。
 *
 * 注意：
 * 这里明确不使用 lunr 默认的 trimmer。
 *
 * 因为 Lunr 2.3.9 的默认 trimmer：
 *
 *   /^\W+/
 *   /\W+$/
 *
 * 会把中文字符当成非 ASCII word character，从而导致：
 *
 *   本地化 -> ""
 *
 * 这正是之前中文搜索完全失效的根本原因。
 */
function unifiedLunrTokenizer(obj, metadata) {
	if (obj == null)
		return [];

	var text = obj.toString();
	var parts = tokenizeText(text);
	var tokens = [];

	for (var i = 0; i < parts.length; i++) {
		var part = parts[i];

		tokens.push(
			new lunr.Token(
				part.text,
				{
					position: [part.start, part.length],
					index: i,
					original: text
				}
			)
		);
	}

	return tokens;
}


/*
 * --------------------------------------------------------------------------
 * Pages
 * --------------------------------------------------------------------------
 */

var pages = [
{% for page in site.pages %}
	{% if page.include_in_search_results and page.title %}
		{% capture parent_url %}/pages/{{ page.parent }}{% endcapture %}
		{% capture grandparent_url %}/pages/{{ page.grandparent }}{% endcapture %}
		{% assign parent_title = "" %}
		{% assign grandparent_title = "" %}

		{% for it_page in site.pages %}
			{% if it_page.url == parent_url %}
				{% assign parent_title = it_page.short_title | default: it_page.title %}
			{% endif %}

			{% if it_page.url == grandparent_url %}
				{% assign grandparent_title = it_page.short_title | default: it_page.title %}
			{% endif %}
		{% endfor %}

		{% if grandparent_title != "" %}
			{% capture parent_title %}{{ grandparent_title }} / {{ parent_title }}{% endcapture %}
		{% endif %}

		{
		"type": "page",
		"title": "{{ page.title }}",
		"url": '<a href="{{ page.url }}.html">',
		"parent_title": "{{ parent_title }}",
		"content": "{{ page.content | markdownify | strip_html | replace: '"', " " | replace: "\", " " | normalize_whitespace }}"
		},
	{% endif %}
{% endfor %}
{% include elements_and_properties.index %}
];


/*
 * --------------------------------------------------------------------------
 * Lunr index
 * --------------------------------------------------------------------------
 */

var idx = lunr(function () {

	this.ref('id');

	this.field('title', {
		boost: 10
	});

	this.field('content');

	this.metadataWhitelist = ['position'];


	/*
	 * 使用统一 tokenizer。
	 *
	 * 这里必须显式替换 Builder tokenizer。
	 *
	 * 同时清空默认 pipeline：
	 *
	 *   tokenizer
	 *   trimmer
	 *   stopWordFilter
	 *   stemmer
	 *
	 * 默认 trimmer 会破坏中文。
	 */
	this.tokenizer = unifiedLunrTokenizer;

	this.pipeline.reset();


	pages.forEach(function (doc, index) {

		doc['id'] = index;

		var type = doc['type'];

		if (
			type == 'element' ||
			type == 'property' ||
			type == 'pseudo'
		) {
			this.add(doc, {
				boost: 10
			});
		}
		else {
			this.add(doc);
		}

	}, this);
});


/*
 * --------------------------------------------------------------------------
 * Query tokenizer
 * --------------------------------------------------------------------------
 *
 * 关键点：
 *
 * 不再：
 *
 *   idx.search(search_term)
 *
 * 因为 idx.search() 会让 Lunr 默认 QueryParser 解析查询字符串，
 * 它不会调用上面 Builder 的 tokenizer。
 *
 * 所以：
 *
 *   索引：unifiedLunrTokenizer()
 *   查询：tokenizeText()
 *
 * 两边使用完全相同的 token 规则。
 */

function searchIndex(searchText) {

	var tokens = tokenizeText(searchText);

	if (!tokens.length)
		return [];


	/*
	 * 去除完全重复的 token。
	 *
	 * 例如连续文本中某些情况下可能生成重复 token。
	 */
	var uniqueTokens = [];
	var seen = {};

	for (var i = 0; i < tokens.length; i++) {
		var token = tokens[i].text;

		if (!token)
			continue;

		if (seen[token])
			continue;

		seen[token] = true;
		uniqueTokens.push(token);
	}


	if (!uniqueTokens.length)
		return [];


	/*
	 * 直接使用 Lunr Query API。
	 *
	 * 每个 token 都作为一个普通 OR 查询项。
	 *
	 * 这样：
	 *
	 *   本地
	 *
	 * 可以命中：
	 *
	 *   本地化
	 *
	 * 因为索引中存在：
	 *
	 *   本地
	 *   地化
	 *
	 * 而：
	 *
	 *   本地化
	 *
	 * 同时存在：
	 *
	 *   本地化
	 *   本地
	 *   地化
	 *
	 * 完整 token 的 TF/匹配效果会自然提高相关性。
	 */
	return idx.query(function (query) {

		for (var i = 0; i < uniqueTokens.length; i++) {

			query.term(
				uniqueTokens[i],
				{
					boost: uniqueTokens[i].length >= 2 ? 2 : 1
				}
			);

		}

	});
}


/*
 * --------------------------------------------------------------------------
 * Result rendering
 * --------------------------------------------------------------------------
 */

function displaySearchResults(has_search_text, results, pages) {

	function mergePositions(positions, new_positions) {

		positions = positions.concat(new_positions);

		positions.sort(function (a, b) {
			return a[0] - b[0];
		});

		for (var i = 0; i < positions.length - 1; i++) {

			var pos = positions[i];
			var pos_next = positions[i + 1];

			if (pos[0] + pos[1] > pos_next[0]) {

				pos[1] = Math.max(
					pos[1],
					pos_next[0] + pos_next[1] - pos[0]
				);

				delete positions[i + 1];
				i--;
			}
		}

		return positions;
	}


	var el_search_results =
		document.getElementById('search-results');


	function insert(str, index, value) {
		return str.substr(0, index) + value + str.substr(index);
	}


	if (results.length && has_search_text) {

		var results_string = '';

		const max_results = 15;
		const max_elements_and_properties = 8;

		var num_elements_and_properties = 0;


		for (
			var i = 0;
			i < results.length &&
			i < max_results + num_elements_and_properties;
			i++
		) {

			var item = pages[results[i].ref];

			var title = item.title;

			const summary_length = 200;

			var content = item.content;
			var type = item.type;


			/*
			 * Split up the href string so that the offline documentation
			 * generator does not rewrite the link.
			 */
			var a_href = '<a href' + '="';

			var url =
				a_href +
				'{{ "" | relative_url }}' +
				item.url.substr(a_href.length);


			if (type != "page") {

				num_elements_and_properties++;

				if (
					num_elements_and_properties >
					max_elements_and_properties
				)
					continue;
			}


			var content_positions = [];
			var title_positions = [];


			for (
				var query in results[i].matchData.metadata
			) {

				var match_objects =
					results[i].matchData.metadata[query];


				if ('content' in match_objects) {

					content_positions =
						mergePositions(
							content_positions,
							match_objects['content'].position
						);
				}


				if ('title' in match_objects) {

					title_positions =
						mergePositions(
							title_positions,
							match_objects['title'].position
						);
				}
			}


			function highlightMatches(
				content,
				positions,
				skip_after_index
			) {

				var cursor = 0;
				var new_content = "";


				for (
					var j = 0;
					j < positions.length;
					j++
				) {

					var pos = positions[j];

					if (
						skip_after_index &&
						pos[0] > skip_after_index
					)
						break;


					new_content +=
						content.slice(cursor, pos[0]) +
						'<strong>' +
						content.slice(
							pos[0],
							pos[0] + pos[1]
						) +
						'</strong>';


					cursor = pos[0] + pos[1];
				}


				new_content += content.slice(cursor);

				return new_content;
			}


			if (content_positions.length) {

				var first_match =
					content_positions[0][0];


				var summary_begin =
					Math.max(
						0,
						content.lastIndexOf(
							' ',
							Math.max(0, first_match - 60)
						)
					);


				var summary_end =
					first_match + summary_length;


				var new_content =
					highlightMatches(
						content,
						content_positions,
						summary_end
					);


				var i_strong =
					new_content.indexOf(
						'</strong>',
						summary_end
					);


				summary_end =
					Math.max(
						new_content.indexOf(
							' ',
							summary_end
						),
						i_strong < 0
							? -1
							: i_strong + '</strong>'.length
					);


				summary_end =
					summary_end < 0
						? new_content.length
						: summary_end;


				content =
					new_content.slice(
						summary_begin,
						summary_end
					);

			}
			else {

				content =
					content.substring(
						0,
						Math.max(
							summary_length,
							content.indexOf(
								' ',
								summary_length
							)
						)
					);
			}


			if (title_positions.length) {

				title =
					highlightMatches(
						title,
						title_positions,
						false
					);
			}


			if (type == "property") {

				results_string +=
					'<h4 title="RCSS property">' +
					'<span class="fas">&#xf121;</span>' +
					url +
					'‘' +
					title +
					'’ property</a></h4>';

			}
			else if (type == "element") {

				results_string +=
					'<h4 title="RML element">' +
					'<span class="fas">&#xf0ce;</span>' +
					url +
					'&lt;' +
					title +
					'&gt; element</a></h4>';

			}
			else if (type == "pseudo") {

				results_string +=
					'<h4 title="Pseudo selector">' +
					'<span class="far">&#xf192;</span>' +
					url +
					' ‘:' +
					title +
					'’ pseudo selector</a></h4>';

			}
			else {

				results_string +=
					'<h4>' +
					url +
					title +
					(
						item.parent_title
							? ' (' + item.parent_title + ')'
							: ''
					) +
					'</a></h4>';


				results_string +=
					'<p>' +
					content +
					'...</p>';
			}
		}


		results_string +=
			'<p style="text-align: right">' +
			'<em>Showing ' +
			Math.min(
				results.length,
				max_results + num_elements_and_properties
			) +
			' of ' +
			results.length +
			' ' +
			(
				results.length == 1
					? 'result'
					: 'results'
			) +
			'.</em></p>';


		el_search_results.innerHTML =
			results_string;

	}
	else if (has_search_text) {

		el_search_results.innerHTML =
			'<p><em>No results found.</em></p>';

	}
	else {

		el_search_results.innerHTML =
			'<p><em>Please enter a search term above.</em></p>';
	}
}


/*
 * --------------------------------------------------------------------------
 * Search events
 * --------------------------------------------------------------------------
 */

var el_search_box =
	document.getElementById('search-box');


function doSearch() {

	var search_term =
		el_search_box.value;


	var results =
		searchIndex(search_term);


	displaySearchResults(
		Boolean(search_term),
		results,
		pages
	);
}


document
	.getElementById('form-search')
	.addEventListener(
		"submit",
		function (e) {

			e.preventDefault();

			doSearch();

			setQueryParam(
				'q',
				el_search_box.value,
				false
			);
		}
	);


document
	.getElementById('search-box')
	.addEventListener(
		"input",
		function (e) {

			doSearch();

			setQueryParam(
				'q',
				el_search_box.value,
				true
			);
		}
	);


window.addEventListener(
	"popstate",
	function (e) {

		var search_term =
			getQueryParam('q');

		el_search_box.value =
			search_term;

		doSearch();
	}
);


el_search_box.value =
	getQueryParam('q');

doSearch();
</script>