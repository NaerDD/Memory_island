package com.memoryisland.web.request;

public class CreateCommentRequest {
    private String authorName;
    private String content;

    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
}
