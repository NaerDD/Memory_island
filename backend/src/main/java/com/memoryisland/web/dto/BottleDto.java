package com.memoryisland.web.dto;

public class BottleDto {
    private Long id;
    private String senderIsland;
    private String mood;
    private String moodLabel;
    private String content;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getSenderIsland() { return senderIsland; }
    public void setSenderIsland(String senderIsland) { this.senderIsland = senderIsland; }
    public String getMood() { return mood; }
    public void setMood(String mood) { this.mood = mood; }
    public String getMoodLabel() { return moodLabel; }
    public void setMoodLabel(String moodLabel) { this.moodLabel = moodLabel; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
}
