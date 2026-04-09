package com.memoryisland.web.dto;

public class MoodDto {
    private String key;
    private String label;
    private String emoji;

    public MoodDto() {
    }

    public MoodDto(String key, String label, String emoji) {
        this.key = key;
        this.label = label;
        this.emoji = emoji;
    }

    public String getKey() { return key; }
    public void setKey(String key) { this.key = key; }
    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }
    public String getEmoji() { return emoji; }
    public void setEmoji(String emoji) { this.emoji = emoji; }
}
