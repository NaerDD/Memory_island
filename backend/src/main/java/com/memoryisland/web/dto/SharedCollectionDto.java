package com.memoryisland.web.dto;

import java.util.List;

public class SharedCollectionDto {
    private Long id;
    private String name;
    private List<String> members;
    private String summary;
    private List<String> items;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public List<String> getMembers() { return members; }
    public void setMembers(List<String> members) { this.members = members; }
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
    public List<String> getItems() { return items; }
    public void setItems(List<String> items) { this.items = items; }
}
