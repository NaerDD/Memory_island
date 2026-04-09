<template>
    <div class="post-list-page">
      <header class="site-header">
        <div class="container nav-inner">
          <div class="site-brand" @click="$router.push('/')">
            <span class="brand-title">小岛记忆</span>
          </div>
  
          <nav class="nav-links">
            <a href="javascript:;" @click="$router.push('/')">首页</a>
            <a href="javascript:;" class="active">文章</a>
            <a href="javascript:;" @click="goCategoryPage">分类</a>
            <a href="javascript:;" @click="goAboutPage">关于</a>
          </nav>
        </div>
      </header>
  
      <section class="page-hero">
        <div class="container">
          <p class="page-subtitle">Posts</p>
          <h1 class="page-title">所有文章</h1>
          <p class="page-desc">
            这里放一些日常记录、随笔、书影摘记和想认真保存下来的时光。
          </p>
        </div>
      </section>
  
      <section class="filter-section">
        <div class="container">
          <div class="filter-bar">
            <button
              v-for="item in categories"
              :key="item"
              class="filter-btn"
              :class="{ active: activeCategory === item }"
              @click="activeCategory = item"
            >
              {{ item }}
            </button>
          </div>
        </div>
      </section>
  
      <section class="post-section">
        <div class="container">
          <div class="post-list">
            <article
              v-for="post in filteredPosts"
              :key="post.id"
              class="post-card"
              @click="goPost(post)"
            >
              <div class="post-meta">
                <span>{{ post.date }}</span>
                <span>{{ post.category }}</span>
                <span>{{ post.readTime }}</span>
              </div>
  
              <h2 class="post-title">{{ post.title }}</h2>
              <p class="post-summary">{{ post.summary }}</p>
  
              <div class="post-footer">
                <span class="read-more">阅读全文</span>
              </div>
            </article>
          </div>
  
          <div v-if="filteredPosts.length === 0" class="empty-state">
            <p>这个分类下暂时还没有文章。</p>
          </div>
        </div>
      </section>
    </div>
  </template>
  
  <script>
  export default {
    name: 'PostList',
    data() {
      return {
        activeCategory: '全部',
        categories: ['全部', '日常', '随笔', '想法', '书影', '回忆'],
        posts: [
          {
            id: 1,
            title: '那些后来想起来很轻的小事',
            summary: '一些原本以为不会记住，但回头看却很想留下来的生活碎片。',
            date: '2026.04.03',
            category: '日常',
            readTime: '3 分钟'
          },
          {
            id: 2,
            title: '在记忆模糊之前，先把感受写下来',
            summary: '有些时候不是忘了发生过什么，而是忘了当时自己是什么感觉。',
            date: '2026.04.01',
            category: '随笔',
            readTime: '4 分钟'
          },
          {
            id: 3,
            title: '一个更安静一点的网站，会更适合记录',
            summary: '比起功能堆满的首页，我更想要一个看起来像“个人角落”的地方。',
            date: '2026.03.28',
            category: '想法',
            readTime: '5 分钟'
          },
          {
            id: 4,
            title: '最近重看的一部电影，像一场很轻的雨',
            summary: '不是那种情节很强烈的片子，但看完之后情绪会停留很久。',
            date: '2026.03.20',
            category: '书影',
            readTime: '4 分钟'
          },
          {
            id: 5,
            title: '一些想认真保存下来的过去时光',
            summary: '记忆不一定总是清晰，但总有一些片段值得被重新整理和收藏。',
            date: '2026.03.12',
            category: '回忆',
            readTime: '6 分钟'
          }
        ]
      }
    },
    computed: {
      filteredPosts() {
        if (this.activeCategory === '全部') {
          return this.posts
        }
        return this.posts.filter(post => post.category === this.activeCategory)
      }
    },
    methods: {
      goPost(post) {
        console.log('进入文章详情：', post)
        // 后面接详情页时改成：
        // this.$router.push(`/post/${post.id}`)
      },
      goCategoryPage() {
        console.log('进入分类页')
        // this.$router.push('/category')
      },
      goAboutPage() {
        console.log('进入关于页')
        // this.$router.push('/about')
      }
    }
  }
  </script>
  
  <style scoped>
  .post-list-page {
    min-height: 100vh;
    background: #fcfcfd;
    color: #1d1d1f;
  }
  
  .container {
    width: 100%;
    max-width: 980px;
    margin: 0 auto;
    padding: 0 24px;
    box-sizing: border-box;
  }
  
  .site-header {
    position: sticky;
    top: 0;
    z-index: 50;
    background: rgba(252, 252, 253, 0.82);
    backdrop-filter: blur(14px);
    border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  }
  
  .nav-inner {
    height: 64px;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }
  
  .site-brand {
    cursor: pointer;
  }
  
  .brand-title {
    font-size: 18px;
    font-weight: 600;
    letter-spacing: -0.2px;
  }
  
  .nav-links {
    display: flex;
    gap: 28px;
    align-items: center;
  }
  
  .nav-links a {
    color: #666;
    text-decoration: none;
    font-size: 14px;
    transition: color 0.25s ease;
  }
  
  .nav-links a:hover,
  .nav-links a.active {
    color: #111;
  }
  
  .page-hero {
    padding: 72px 0 36px;
  }
  
  .page-subtitle {
    font-size: 13px;
    color: #8a8a8f;
    margin-bottom: 12px;
    letter-spacing: 0.08em;
  }
  
  .page-title {
    margin: 0 0 14px;
    font-size: 48px;
    line-height: 1.18;
    font-weight: 600;
    letter-spacing: -1.2px;
  }
  
  .page-desc {
    max-width: 680px;
    font-size: 18px;
    line-height: 1.9;
    color: #6e6e73;
    margin: 0;
  }
  
  .filter-section {
    padding: 8px 0 20px;
  }
  
  .filter-bar {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
  }
  
  .filter-btn {
    border: 1px solid rgba(0, 0, 0, 0.08);
    background: #fff;
    color: #555;
    border-radius: 999px;
    padding: 8px 16px;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.22s ease;
  }
  
  .filter-btn:hover {
    border-color: rgba(0, 0, 0, 0.15);
    color: #111;
  }
  
  .filter-btn.active {
    background: #1d1d1f;
    color: #fff;
    border-color: #1d1d1f;
  }
  
  .post-section {
    padding: 12px 0 72px;
  }
  
  .post-list {
    display: grid;
    gap: 18px;
  }
  
  .post-card {
    background: #fff;
    border: 1px solid rgba(0, 0, 0, 0.06);
    border-radius: 24px;
    padding: 26px 28px;
    cursor: pointer;
    transition: transform 0.22s ease, box-shadow 0.22s ease;
  }
  
  .post-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 12px 28px rgba(0, 0, 0, 0.05);
  }
  
  .post-meta {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
    color: #8a8a8f;
    font-size: 13px;
    margin-bottom: 12px;
  }
  
  .post-title {
    margin: 0 0 12px;
    font-size: 24px;
    line-height: 1.5;
    font-weight: 600;
    letter-spacing: -0.3px;
  }
  
  .post-summary {
    margin: 0;
    color: #6e6e73;
    line-height: 1.9;
    font-size: 15px;
  }
  
  .post-footer {
    margin-top: 18px;
  }
  
  .read-more {
    font-size: 14px;
    color: #3b6edc;
  }
  
  .empty-state {
    padding: 40px 0;
    text-align: center;
    color: #8a8a8f;
    font-size: 15px;
  }
  
  @media (max-width: 768px) {
    .page-title {
      font-size: 34px;
      letter-spacing: -0.8px;
    }
  
    .page-desc {
      font-size: 16px;
      line-height: 1.9;
    }
  
    .nav-links {
      gap: 16px;
    }
  
    .post-title {
      font-size: 20px;
    }
  }
  
  @media (max-width: 640px) {
    .nav-inner {
      height: auto;
      padding: 14px 0;
      flex-direction: column;
      align-items: flex-start;
      gap: 10px;
    }
  
    .nav-links {
      flex-wrap: wrap;
      gap: 14px;
    }
  }
  </style>