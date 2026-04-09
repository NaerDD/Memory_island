package com.memoryisland.web.dto;

import java.util.List;

public class OverviewResponse {
    private String islandName;
    private String bio;
    private Integer memoryCount;
    private MoodDto currentMood;
    private List<MoodDto> moods;
    private List<BuildingDto> buildings;
    private List<BottleDto> bottles;
    private List<SharedCollectionDto> collections;

    public String getIslandName() { return islandName; }
    public void setIslandName(String islandName) { this.islandName = islandName; }
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
    public Integer getMemoryCount() { return memoryCount; }
    public void setMemoryCount(Integer memoryCount) { this.memoryCount = memoryCount; }
    public MoodDto getCurrentMood() { return currentMood; }
    public void setCurrentMood(MoodDto currentMood) { this.currentMood = currentMood; }
    public List<MoodDto> getMoods() { return moods; }
    public void setMoods(List<MoodDto> moods) { this.moods = moods; }
    public List<BuildingDto> getBuildings() { return buildings; }
    public void setBuildings(List<BuildingDto> buildings) { this.buildings = buildings; }
    public List<BottleDto> getBottles() { return bottles; }
    public void setBottles(List<BottleDto> bottles) { this.bottles = bottles; }
    public List<SharedCollectionDto> getCollections() { return collections; }
    public void setCollections(List<SharedCollectionDto> collections) { this.collections = collections; }
}
