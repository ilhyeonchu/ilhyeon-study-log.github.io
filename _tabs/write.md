---
layout: page
title: 글쓰기
icon: fas fa-pen
order: 4
---

아래 버튼을 누르면 이 리포지토리의 `_posts` 폴더에 새 글을 만드는 GitHub 웹 에디터가 열립니다.

<button id="start-writing" class="btn btn-primary">글쓰기 시작하기</button>

<script>
  (function () {
    function buildUrl() {
      const repo = 'ilhyeonchu/ilhyeon-study-log.github.io';
      const now = new Date();
      const yyyy = now.getFullYear();
      const mm = String(now.getMonth() + 1).padStart(2, '0');
      const dd = String(now.getDate()).padStart(2, '0');

      const filename = `${yyyy}-${mm}-${dd}-your-title.md`;
      const tz = '+0900';

      const template = `---\n` +
        `layout: post\n` +
        `title: ""\n` +
        `date: ${yyyy}-${mm}-${dd} 09:00 ${tz}\n` +
        `categories: [Blog]\n` +
        `tags: []\n` +
        `---\n\n` +
        `여기에 내용을 작성하세요.\n`;

      const base = `https://github.com/${repo}/new/HEAD/_posts`;
      const params = new URLSearchParams({
        filename,
        value: template
      });
      return `${base}?${params.toString()}`;
    }

    const btn = document.getElementById('start-writing');
    if (btn) {
      btn.addEventListener('click', function () {
        window.location.href = buildUrl();
      });
    }
  })();
</script>
