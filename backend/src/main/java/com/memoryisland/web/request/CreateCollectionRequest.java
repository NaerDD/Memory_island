package com.memoryisland.web.request;

public class CreateCollectionRequest {
    private String name;
    private String members;
    private String summary;

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getMembers() { return members; }
    public void setMembers(String members) { this.members = members; }
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
}
