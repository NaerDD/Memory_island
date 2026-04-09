package com.memoryisland.web.request;

public class CreateMemoryRequest {
    private Long buildingId;
    private String title;
    private String happenedAt;
    private String mediaType;
    private String content;

    public Long getBuildingId() { return buildingId; }
    public void setBuildingId(Long buildingId) { this.buildingId = buildingId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getHappenedAt() { return happenedAt; }
    public void setHappenedAt(String happenedAt) { this.happenedAt = happenedAt; }
    public String getMediaType() { return mediaType; }
    public void setMediaType(String mediaType) { this.mediaType = mediaType; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
}
