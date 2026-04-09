package com.memoryisland.entity;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "bottles")
public class BottleMessage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String senderIsland;
    private String mood;
    private String moodLabel;

    @Column(length = 2000)
    private String content;

    private LocalDateTime createdAt;

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
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
