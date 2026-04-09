package com.memoryisland.web;

import com.memoryisland.service.MemoryIslandService;
import com.memoryisland.web.dto.MemoryDto;
import com.memoryisland.web.dto.OverviewResponse;
import com.memoryisland.web.dto.BottleDto;
import com.memoryisland.web.dto.SharedCollectionDto;
import com.memoryisland.web.dto.TopicDto;
import com.memoryisland.web.request.CreateBottleRequest;
import com.memoryisland.web.request.CreateCollectionRequest;
import com.memoryisland.web.request.CreateMemoryRequest;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class MemoryIslandController {

    private final MemoryIslandService memoryIslandService;

    public MemoryIslandController(MemoryIslandService memoryIslandService) {
        this.memoryIslandService = memoryIslandService;
    }

    @GetMapping("/overview")
    public OverviewResponse overview() {
        return memoryIslandService.getOverview();
    }

    @GetMapping("/topics/today")
    public TopicDto todayTopic() {
        return memoryIslandService.getTodayTopic();
    }

    @GetMapping("/topics/next")
    public TopicDto nextTopic() {
        return memoryIslandService.nextTopic();
    }

    @GetMapping("/memories")
    public List<MemoryDto> memories() {
        return memoryIslandService.listMemories();
    }

    @GetMapping("/memories/{id}")
    public MemoryDto memoryDetail(@PathVariable Long id) {
        return memoryIslandService.getMemory(id);
    }

    @PostMapping("/memories")
    public MemoryDto createMemory(@RequestBody CreateMemoryRequest request) {
        return memoryIslandService.createMemory(request);
    }

    @PostMapping("/bottles")
    public BottleDto createBottle(@RequestBody CreateBottleRequest request) {
        return memoryIslandService.createBottle(request);
    }

    @PostMapping("/collections")
    public SharedCollectionDto createCollection(@RequestBody CreateCollectionRequest request) {
        return memoryIslandService.createCollection(request);
    }
}
