items <- function(dir) {
  f <- Sys.glob(file.path(dir, "*", "index.qmd"))
  if (!length(f)) return(NULL)
  m <- lapply(f, rmarkdown::yaml_front_matter)
  g <- function(k) vapply(m, function(x) if (is.null(x[[k]])) NA_character_ else paste(as.character(x[[k]]), collapse = " "), "")
  d <- data.frame(path = f, title = g("title"), date = as.Date(g("date")), image = g("image"), summary = g("summary"))
  d[order(d$date, decreasing = TRUE), ]
}

entries <- function(d) {
  img <- gsub(" ", "%20", file.path(dirname(d$path), d$image), fixed = TRUE)
  thumb <- ifelse(is.na(d$image), "", sprintf("![](%s){.entry-thumb .nolightbox}\n\n", img))
  date <- ifelse(is.na(d$date), "", sub("^0", "", tolower(format(d$date, "%d %B %Y"))))
  summ <- ifelse(is.na(d$summary), "", d$summary)
  sprintf(paste0(":::: {.entry}\n\n::: {.entry-top}\n\n%s::: {.entry-meta}\n\n",
                 "[%s](%s){.entry-title .stretched-link}\n\n[%s]{.entry-date}\n\n:::\n\n:::\n\n%s\n\n::::\n\n"),
          thumb, d$title, d$path, date, summ)
}

panels <- function(x) {
  cols <- vapply(names(x), function(k) {
    d <- items(k)
    body <- if (is.null(d)) "[nothing here yet.]{.entry-empty}\n\n" else paste(entries(d), collapse = "")
    paste0("::::: {.panel-col}\n\n[", x[[k]], "]{.panel-head}\n\n", body, ":::::\n\n")
  }, "")
  cat("::::::: {.panels}\n\n", cols, ":::::::\n", sep = "")
}

photo_md <- function(paths, caps, group) {
  if (!length(paths)) return(cat("no photos yet.\n"))
  cat("::: {.photo-grid}\n\n",
      sprintf('![%s](%s){group="%s"}\n\n', gsub("[\r\n]+", " ", caps), gsub(" ", "%20", paths, fixed = TRUE), group),
      ":::\n", sep = "")
}

gallery_set <- function(dir, captions) {
  imgs <- list.files(dir, pattern = "(?i)\\.(jpe?g|png|webp)$")
  if (!length(imgs)) return(data.frame(path = character(), caption = character()))
  cap <- if (file.exists(captions)) read.csv(captions, fileEncoding = "UTF-8-BOM", stringsAsFactors = FALSE) else data.frame(file = character(), caption = character())
  ord <- c(intersect(cap$file, imgs), sort(setdiff(imgs, cap$file)))
  txt <- as.character(cap$caption[match(ord, cap$file)])
  data.frame(path = file.path(dir, ord), caption = ifelse(is.na(txt), "", txt))
}

photo_grid <- function(dirs = "photos", captions = "captions.csv", group = "gallery") {
  s <- do.call(rbind, unname(Map(gallery_set, dirs, captions)))
  photo_md(s$path, s$caption, group)
}

section_gallery <- function(dirs) {
  imgs <- list.files(dirs, pattern = "(?i)\\.(jpe?g|png|webp)$", recursive = TRUE, full.names = TRUE)
  imgs <- sort(imgs[!grepl("^thumb\\.", basename(imgs))], decreasing = TRUE)
  photo_md(imgs, rep("", length(imgs)), "section")
}
