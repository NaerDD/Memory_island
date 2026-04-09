package com.memoryisland.entity;

import javax.persistence.*;

@Entity
@Table(name = "shared_collections")
public class SharedCollection {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String members;

    @Column(length = 2000)
    private String summary;

    @Column(length = 3000)
    private String items;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getMembers() { return members; }
    public void setMembers(String members) { this.members = members; }
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
    public String getItems() { return items; }
    public void setItems(String items) { this.items = items; }
}
