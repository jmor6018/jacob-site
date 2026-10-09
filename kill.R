system("taskkill /F /T /IM quarto.exe", ignore.stdout = TRUE, ignore.stderr = TRUE)
system("taskkill /F /T /IM deno.exe", ignore.stdout = TRUE, ignore.stderr = TRUE)
site <- path.expand("~/jacob-site")
unlink(file.path(site, c("docs", ".quarto")), recursive = TRUE)
system2("quarto", c("preview", shQuote(site)), wait = FALSE)









# ---- github (first run only) ----
if (!dir.exists(file.path(site, ".git"))) {
  setwd(site)
  usethis::create_github_token()
  gitcreds::gitcreds_set()
  usethis::use_git()
  usethis::use_github()
}







