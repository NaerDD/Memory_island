package com.memoryisland.web.dto;

import java.util.List;

public class MemoryDto {
    private Long id;
    private Long buildingId;
    private String title;
    private String happenedAt;
    private String weather;
    private List<String> mediaTypes;
    private List<String> emotions;
    private String content;
    private String buildingName;
    private String buildingType;
    private String buildingIcon;
    private String excerpt;
    private List<CommentDto> comments;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getBuildingId() { return buildingId; }
    public void setBuildingId(Long buildingId) { this.buildingId = buildingId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getHappenedAt() { return happenedAt; }
    public void setHappenedAt(String happenedAt) { this.happenedAt = happenedAt; }
    public String getWeather() { return weather; }
    public void setWeather(String weather) { this.weather = weather; }
    public List<String> getMediaTypes() { return mediaTypes; }
    public void setMediaTypes(List<String> mediaTypes) { this.mediaTypes = mediaTypes; }
    public List<String> getEmotions() { return emotions; }
    public void setEmotions(List<String> emotions) { this.emotions = emotions; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getBuildingName() { return buildingName; }
    public void setBuildingName(String buildingName) { this.buildingName = buildingName; }
    public String getBuildingType() { return buildingType; }
    public void setBuildingType(String buildingType) { this.buildingType = buildingType; }
    public String getBuildingIcon() { return buildingIcon; }
    public void setBuildingIcon(String buildingIcon) { this.buildingIcon = buildingIcon; }
    public String getExcerpt() { return excerpt; }
    public void setExcerpt(String excerpt) { this.excerpt = excerpt; }
    public List<CommentDto> getComments() { return comments; }
    public void setComments(List<CommentDto> comments) { this.comments = comments; }
}
