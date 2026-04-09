package com.memoryisland.entity;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "memories")
public class MemoryRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "building_id")
    private Building building;

    private String title;
    private LocalDate happenedAt;
    private String weather;
    private String mediaTypes;
    private String emotions;

    @Column(length = 4000)
    private String content;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Building getBuilding() { return building; }
    public void setBuilding(Building building) { this.building = building; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public LocalDate getHappenedAt() { return happenedAt; }
    public void setHappenedAt(LocalDate happenedAt) { this.happenedAt = happenedAt; }
    public String getWeather() { return weather; }
    public void setWeather(String weather) { this.weather = weather; }
    public String getMediaTypes() { return mediaTypes; }
    public void setMediaTypes(String mediaTypes) { this.mediaTypes = mediaTypes; }
    public String getEmotions() { return emotions; }
    public void setEmotions(String emotions) { this.emotions = emotions; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
}
