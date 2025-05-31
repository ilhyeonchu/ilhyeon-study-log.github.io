---
layout: page # Using Chirpy's 'page' layout or our default that includes profile/sidebar
title: "글 작성 도우미"
permalink: /write/
---
<div id="write-page-content-wrapper">
  <p style="padding:10px; background-color:#fffbcc; border:1px solid #e6db55; border-radius:5px;">
    <strong>참고:</strong> 이 페이지는 블로그 글의 마크다운 형식을 만드는 데 도움을 주는 도구입니다.
    여기서 "발행" 버튼을 눌러도 실제 블로그에 글이 게시되지 않습니다.
    <br>글을 완성한 후에는 "Copy Full Markdown" 버튼을 눌러 생성된 내용을 복사하여 <code>_posts</code> 폴더에 <code>YYYY-MM-DD-제목.md</code> 형식의 새 파일을 만들어 붙여넣고, Git에 커밋/푸시해야 합니다.
    <br>카테고리, 제목, 날짜 등은 파일 상단의 Front Matter에 정확히 기입해주세요. (이 페이지가 Front Matter 생성을 돕습니다.)
  </p>

  <div class="main-content">
    <h1>새 글 작성</h1> <!-- This h1 is part of the main content area -->
<div class="write-form">
  <div class="form-group">
    <label for="post-title">제목</label>
    <input type="text" id="post-title" class="form-control" placeholder="제목을 입력하세요">
  </div>

  <div class="form-group">
    <label>태그 (Leaf Categories)</label>
    <div id="leaf-category-tags-container" style="border: 1px solid #ddd; padding: 10px; max-height: 200px; overflow-y: auto;">
      {% assign category_graph = site.data.category_graph %}
      {% assign leaf_categories = '' | split: ',' %}
      {% if category_graph %}
        {% for node_id_keyval in category_graph %}
          {% assign node_id = node_id_keyval[0] %}
          {% assign node = node_id_keyval[1] %}
          {% assign is_leaf = true %}
          {% if node.children and node.children.size > 0 %}
            {% assign is_leaf = false %}
          {% endif %}
          {% if is_leaf %}
            <label style="display: block; margin-bottom: 5px;">
              <input type="checkbox" class="leaf-category-tag-checkbox" value="{{ node_id }}">
              {{ node.name }} (ID: <code>{{ node_id }}</code>)
            </label>
          {% endif %}
        {% endfor %}
      {% else %}
        <p>No category data found. Check <code>_data/category_graph.yml</code>.</p>
      {% endif %}
    </div>
  </div>

  <div class="form-group">
    <label>Suggested Front Matter Tags:</label>
    <textarea id="suggested-tags-frontmatter" class="form-control" rows="3" readonly placeholder="Select tags above to see suggested front matter..."></textarea>
  </div>

  <div class="form-group">
    <label for="post-content">내용 (Markdown)</label>
    <div id="editor">
      <div class="editor-toolbar">
        <button type="button" class="toolbar-btn" data-command="bold">B</button>
        <button type="button" class="toolbar-btn" data-command="italic">I</button>
        <button type="button" class="toolbar-btn" data-command="underline">U</button>
        <button type="button" class="toolbar-btn" data-command="insertOrderedList">1.</button>
        <button type="button" class="toolbar-btn" data-command="insertUnorderedList">&bull;</button>
        <button type="button" class="toolbar-btn" data-command="createLink">Link</button>
        <button type="button" class="toolbar-btn" data-command="insertImage">Image</button>
        {% comment %} Add more markdown buttons if needed {% endcomment %}
      </div>
      <textarea id="markdown-editor-content" class="editor-content" style="width:100%; min-height:300px; border:1px solid #ccc; padding:10px; box-sizing: border-box;" placeholder="Write your Markdown content here..."></textarea>
    </div>
  </div>

  <div class="form-actions">
    <button type="button" id="copy-markdown-output" class="btn btn-info">Copy Full Markdown</button>
    {% comment %}
    <button type="button" id="save-draft" class="btn btn-secondary">임시저장</button>
    <button type="button" id="publish-post" class="btn btn-primary">발행</button>
    These buttons don't do anything on a static site, text changed for clarity.
    {% endcomment %}
  </div>

  <div class="form-group" style="margin-top: 20px;">
      <label>Generated Post Structure (Copy this):</label>
      <textarea id="full-post-output" class="form-control" rows="15" readonly style="font-family: monospace; white-space: pre;"></textarea>
  </div>
</div>
  </div> <!-- Closing main-content -->


<script>
document.addEventListener('DOMContentLoaded', function() {
  // --- NEW: Leaf Category Tag Checkbox Logic ---
  const checkboxesContainer = document.getElementById('leaf-category-tags-container');
  const suggestedTagsTextarea = document.getElementById('suggested-tags-frontmatter');
  const fullPostOutputTextarea = document.getElementById('full-post-output');
  const postTitleInput = document.getElementById('post-title');
  const markdownEditor = document.getElementById('markdown-editor-content'); // This was the ID of the textarea in the plan
  const copyMarkdownButton = document.getElementById('copy-markdown-output');

  function updateSuggestedFrontMatter() {
    const selectedTags = [];
    if (checkboxesContainer) {
        checkboxesContainer.querySelectorAll('.leaf-category-tag-checkbox:checked').forEach(checkbox => {
          selectedTags.push(checkbox.value);
        });
    }
    if (suggestedTagsTextarea) {
        if (selectedTags.length > 0) {
          suggestedTagsTextarea.value = "tags: [" + selectedTags.join(', ') + "]";
        } else {
          suggestedTagsTextarea.value = "tags: []";
        }
    }
    updateFullPostOutput();
  }

  if (checkboxesContainer) {
    checkboxesContainer.addEventListener('change', function(event) {
      if (event.target.classList.contains('leaf-category-tag-checkbox')) {
        updateSuggestedFrontMatter();
      }
    });
  }
  // Initialize once for current state (e.g. if some checkboxes were checked by browser cache)
  if (suggestedTagsTextarea) { // Check if element exists
      updateSuggestedFrontMatter();
  }


  // --- Editor Toolbar JS (adapted for Markdown textarea) ---
  const toolbar = document.querySelectorAll('.toolbar-btn');
  const markdownEditorTextarea = document.getElementById('markdown-editor-content'); // Corrected variable name

  function insertMarkdown(syntax, placeholder = 'text') {
    if (!markdownEditorTextarea) return;
    const start = markdownEditorTextarea.selectionStart;
    const end = markdownEditorTextarea.selectionEnd;
    const text = markdownEditorTextarea.value;
    let newText = '';
    const selectedText = text.substring(start, end) || placeholder;

    switch (syntax) {
      case 'bold': newText = '**' + selectedText + '**'; break;
      case 'italic': newText = '*' + selectedText + '*'; break;
      case 'underline': newText = '<u>' + selectedText + '</u>'; break; // Note: <u> is HTML, not standard Markdown
      case 'insertOrderedList': newText = '\\n1. ' + selectedText.replace(/\\n/g, '\\n1. '); break;
      case 'insertUnorderedList': newText = '\\n- ' + selectedText.replace(/\\n/g, '\\n- '); break;
      case 'custom': newText = selectedText; break; // For link/image where selectedText is already formatted
      default: newText = selectedText;
    }
    markdownEditorTextarea.value = text.substring(0, start) + newText + text.substring(end);
    updateFullPostOutput();
  }

  toolbar.forEach(btn => {
    btn.addEventListener('click', function() {
      const command = this.dataset.command;
      if (command === 'createLink') {
        const url = prompt('Enter link URL:', 'http://');
        if (url) {
          const selectedText = markdownEditorTextarea.value.substring(markdownEditorTextarea.selectionStart, markdownEditorTextarea.selectionEnd) || 'link text';
          insertMarkdown('custom', '[' + selectedText + '](' + url + ')');
        }
      } else if (command === 'insertImage') {
        const imgUrl = prompt('Enter image URL:', 'http://');
        if (imgUrl) {
          const altText = prompt('Enter image alt text:', 'image');
          insertMarkdown('custom', '![' + altText + '](' + imgUrl + ')');
        }
      } else {
        insertMarkdown(command);
      }
    });
  });

  // --- Generate Full Post Output ---
  function updateFullPostOutput() {
    if (!postTitleInput || !suggestedTagsTextarea || !markdownEditorTextarea || !fullPostOutputTextarea) return;

    const title = postTitleInput.value || 'Your Post Title';
    const tagsFrontMatter = suggestedTagsTextarea.value;
    const content = markdownEditorTextarea.value;
    // Get current date in YYYY-MM-DD format
    const today = new Date();
    const year = today.getFullYear();
    const month = ('0' + (today.getMonth() + 1)).slice(-2); // Months are zero-based
    const day = ('0' + today.getDate()).slice(-2);
    const date = year + '-' + month + '-' + day;

    const frontMatter = \`---
layout: post
title: "\${title}"
date: \${date}
\${tagsFrontMatter}
---

\`;
    fullPostOutputTextarea.value = frontMatter + content;
  }

  // Add event listeners
  if (postTitleInput) postTitleInput.addEventListener('input', updateFullPostOutput);
  if (markdownEditorTextarea) markdownEditorTextarea.addEventListener('input', updateFullPostOutput);

  // Initial generation of frontmatter and full output
  updateFullPostOutput();

  if (copyMarkdownButton) {
    copyMarkdownButton.addEventListener('click', function() {
      if (fullPostOutputTextarea) {
        fullPostOutputTextarea.select();
        try {
          var successful = document.execCommand('copy');
          var msg = successful ? 'successful' : 'unsuccessful';
          alert('Post content copy ' + msg + '!');
        } catch (err) {
          alert('Failed to copy post content. Please copy manually.');
        }
      }
    });
  }
});
</script>
</div> <!-- Closing write-page-content-wrapper -->
