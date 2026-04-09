package com.memoryisland.web.request;

public class CreateMemoryRequest {
    private Long buildingId;
    private String title;
    private String happenedAt;
    private String weather;
    private String mediaType;
    private String emotions;
    private String content;

    public Long getBuildingId() { return buildingId; }
    public void setBuildingId(Long buildingId) { this.buildingId = buildingId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getHappenedAt() { return happenedAt; }
    public void setHappenedAt(String happenedAt) { this.happenedAt = happenedAt; }
    public String getWeather() { return weather; }
    public void setWeather(String weather) { this.weather = weather; }
    public String getMediaType() { return mediaType; }
    public void setMediaType(String mediaType) { this.mediaType = mediaType; }
    public String getEmotions() { return emotions; }
    public void setEmotions(String emotions) { this.emotions = emotions; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
}
