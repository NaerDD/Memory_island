package com.memoryisland.web.request;

public class UpsertBuildingRequest {
    private String name;
    private String type;
    private String icon;
    private String summary;

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
}
