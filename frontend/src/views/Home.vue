<template>
  <div class="home">
    <el-container>
      <el-header>
        <h1>项目管理系统</h1>
      </el-header>
      <el-main>
        <el-card>
          <div>Welcome to the application!</div>
        </el-card>
      </el-main>
    </el-container>
  </div>
</template>

<script>
export default {
  name: 'Home'
}
</script>

<style scoped>
.home {
  height: 100%;
}

.el-header {
  background-color: #409EFF;
  color: #fff;
  text-align: center;
  line-height: 60px;
}

.el-main {
  background-color: #f5f5f5;
  padding: 20px;
}
</style>