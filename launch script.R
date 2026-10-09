setwd("~/jacob-site")
usethis::use_git_config(user.name = "jmor6018", user.email = "jakerose42@outlook.com")
system("taskkill /F /T /IM quarto.exe", ignore.stdout = TRUE, ignore.stderr = TRUE)
system2("quarto", c("render", "."))
usethis::create_github_token()
gitcreds::gitcreds_set()
usethis::use_git()




setwd("~/jacob-site")
usethis::use_github()
