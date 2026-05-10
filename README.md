# 熊先生个人简历网站

这是一个纯静态个人网站，可直接部署到 GitHub Pages。

简历内容来源只使用用户指定的有效简历。同目录其它简历文件均为废弃版本，不作为网站素材或下载附件。对外展示与下载版本统一使用“熊先生”。

## 本地预览

```bash
cd personal-site
python3 -m http.server 8080
```

打开 `http://localhost:8080`。

## GitHub Pages 发布

当前机器未登录 GitHub CLI。登录后可用以下命令一键发布，并自动把公网链接写入每日投递配置：

```bash
cd /Users/jiex/Desktop/我的文件/面试/personal-site
gh auth login
./scripts/publish_github_pages.sh
```

如果旧仓库已经公开过真实姓名，发布新站后在本机执行：

```bash
OLD_GITHUB_REPO=<旧仓库名> ./scripts/delete_old_public_repo.sh
```

该脚本会删除旧公开仓库，避免旧 URL 和旧提交继续暴露真实姓名。

发布后访问：

```text
https://<你的GitHub用户名>.github.io/mr-xiong-resume-site/
```

发布脚本会同步更新 `../job-automation/config/profile.json` 中的 `personal_site_url`，后续每日投递话术和自动生成简历会自动带上该网站链接。

投递时可附带：

> 除附件简历外，我也整理了个人项目与经历网站，便于快速了解我的数仓建设、ETL、金融图谱与 Vibe Coding / AI辅助开发经验。
