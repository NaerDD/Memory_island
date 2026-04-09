package com.memoryisland.web.dto;

import java.util.List;

public class BuildingDto {
    private Long id;
    private String name;
    private String type;
    private String icon;
    private String summary;
    private List<MemoryDto> memories;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
    public List<MemoryDto> getMemories() { return memories; }
    public void setMemories(List<MemoryDto> memories) { this.memories = memories; }
}
