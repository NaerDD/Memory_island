package com.memoryisland.service;

import com.memoryisland.entity.BottleMessage;
import com.memoryisland.entity.Building;
import com.memoryisland.entity.MemoryComment;
import com.memoryisland.entity.MemoryRecord;
import com.memoryisland.entity.SharedCollection;
import com.memoryisland.repository.MemoryCommentRepository;
import com.memoryisland.repository.BottleMessageRepository;
import com.memoryisland.repository.BuildingRepository;
import com.memoryisland.repository.MemoryRecordRepository;
import com.memoryisland.repository.SharedCollectionRepository;
import com.memoryisland.web.dto.*;
import com.memoryisland.web.request.CreateBottleRequest;
import com.memoryisland.web.request.CreateCommentRequest;
import com.memoryisland.web.request.CreateCollectionRequest;
import com.memoryisland.web.request.CreateMemoryRequest;
import com.memoryisland.web.request.UpsertBuildingRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class MemoryIslandService {

    private final BuildingRepository buildingRepository;
    private final MemoryRecordRepository memoryRecordRepository;
    private final BottleMessageRepository bottleMessageRepository;
    private final SharedCollectionRepository sharedCollectionRepository;
    private final MemoryCommentRepository memoryCommentRepository;

    private final List<TopicDto> topics = Arrays.asList(
            new TopicDto("你第一次认真看海，是在什么地方，和谁一起，风是什么味道？", "不要只写发生了什么，也写温度、气味、衣服颜色和身体感受。"),
            new TopicDto("小时候有哪一个下午，你以为会永远持续下去？", "试着回忆光线、声音、陪在身边的人，以及你那时正在相信什么。"),
            new TopicDto("有没有一顿饭，后来想起来才发现它其实很重要？", "把桌上的菜、说过的话和散场后的情绪一起记下来。")
    );

    private int topicIndex = 0;

    public MemoryIslandService(BuildingRepository buildingRepository,
                               MemoryRecordRepository memoryRecordRepository,
                               BottleMessageRepository bottleMessageRepository,
                               SharedCollectionRepository sharedCollectionRepository,
                               MemoryCommentRepository memoryCommentRepository) {
        this.buildingRepository = buildingRepository;
        this.memoryRecordRepository = memoryRecordRepository;
        this.bottleMessageRepository = bottleMessageRepository;
        this.sharedCollectionRepository = sharedCollectionRepository;
        this.memoryCommentRepository = memoryCommentRepository;
    }

    public OverviewResponse getOverview() {
        OverviewResponse response = new OverviewResponse();
        response.setIslandName("雾灯岛");
        response.setBio("给容易遗失的记忆一块能停靠的岸。这里把人生阶段变成建筑，把共同经历变成能被反复补写的空间。");
        response.setCurrentMood(new MoodDto("nostalgia", "怀念", "🕊️"));
        response.setMoods(Arrays.asList(
                new MoodDto("calm", "平静", "🌊"),
                new MoodDto("happy", "轻快", "☀️"),
                new MoodDto("nostalgia", "怀念", "🕊️"),
                new MoodDto("lonely", "孤单", "🌙")
        ));

        List<BuildingDto> buildings = buildingRepository.findAll().stream()
                .sorted(Comparator.comparing(Building::getId))
                .map(this::toBuildingDto)
                .collect(Collectors.toList());
        response.setBuildings(buildings);
        response.setMemoryCount(buildings.stream().mapToInt(item -> item.getMemories().size()).sum());

        response.setBottles(bottleMessageRepository.findAll().stream()
                .sorted(Comparator.comparing(BottleMessage::getId).reversed())
                .map(this::toBottleDto)
                .collect(Collectors.toList()));

        response.setCollections(sharedCollectionRepository.findAll().stream()
                .sorted(Comparator.comparing(SharedCollection::getId).reversed())
                .map(this::toCollectionDto)
                .collect(Collectors.toList()));
        return response;
    }

    public TopicDto getTodayTopic() {
        return topics.get(topicIndex);
    }

    public TopicDto nextTopic() {
        topicIndex = (topicIndex + 1) % topics.size();
        return topics.get(topicIndex);
    }

    public List<MemoryDto> listMemories() {
        return memoryRecordRepository.findAllByOrderByHappenedAtDescIdDesc().stream()
                .map(this::toMemoryDto)
                .collect(Collectors.toList());
    }

    public MemoryDto getMemory(Long id) {
        MemoryRecord record = memoryRecordRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("回忆不存在"));
        return toMemoryDto(record);
    }

    @Transactional
    public BuildingDto createBuilding(UpsertBuildingRequest request) {
        Building building = new Building();
        applyBuilding(building, request);
        return toBuildingDto(buildingRepository.save(building));
    }

    @Transactional
    public BuildingDto updateBuilding(Long id, UpsertBuildingRequest request) {
        Building building = buildingRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("建筑不存在"));
        applyBuilding(building, request);
        return toBuildingDto(buildingRepository.save(building));
    }

    @Transactional
    public MemoryDto createMemory(CreateMemoryRequest request) {
        Building building = buildingRepository.findById(request.getBuildingId())
                .orElseThrow(() -> new IllegalArgumentException("建筑不存在"));
        MemoryRecord record = new MemoryRecord();
        applyMemory(record, building, request);
        MemoryRecord saved = memoryRecordRepository.save(record);
        return toMemoryDto(saved);
    }

    @Transactional
    public MemoryDto updateMemory(Long id, CreateMemoryRequest request) {
        MemoryRecord record = memoryRecordRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("回忆不存在"));
        Building building = buildingRepository.findById(request.getBuildingId())
                .orElseThrow(() -> new IllegalArgumentException("建筑不存在"));
        applyMemory(record, building, request);
        MemoryRecord saved = memoryRecordRepository.save(record);
        return toMemoryDto(saved);
    }

    @Transactional
    public void deleteMemory(Long id) {
        MemoryRecord record = memoryRecordRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("回忆不存在"));
        memoryRecordRepository.delete(record);
    }

    @Transactional
    public BottleDto createBottle(CreateBottleRequest request) {
        BottleMessage bottle = new BottleMessage();
        bottle.setSenderIsland("雾灯岛");
        bottle.setMood(request.getMood());
        bottle.setMoodLabel(moodLabel(request.getMood()));
        bottle.setContent(request.getContent());
        bottle.setCreatedAt(LocalDateTime.now());
        BottleMessage saved = bottleMessageRepository.save(bottle);
        return toBottleDto(saved);
    }

    @Transactional
    public SharedCollectionDto createCollection(CreateCollectionRequest request) {
        SharedCollection collection = new SharedCollection();
        collection.setName(request.getName());
        collection.setMembers(request.getMembers());
        collection.setSummary(request.getSummary());
        collection.setItems("写下这段共同经历的起点");
        SharedCollection saved = sharedCollectionRepository.save(collection);
        return toCollectionDto(saved);
    }

    @Transactional
    public CommentDto createComment(Long memoryId, CreateCommentRequest request) {
        MemoryRecord memory = memoryRecordRepository.findById(memoryId)
                .orElseThrow(() -> new IllegalArgumentException("回忆不存在"));
        MemoryComment comment = new MemoryComment();
        comment.setMemory(memory);
        comment.setAuthorName(request.getAuthorName());
        comment.setContent(request.getContent());
        comment.setCreatedAt(LocalDateTime.now());
        return toCommentDto(memoryCommentRepository.save(comment));
    }

    private BuildingDto toBuildingDto(Building building) {
        BuildingDto dto = new BuildingDto();
        dto.setId(building.getId());
        dto.setName(building.getName());
        dto.setType(building.getType());
        dto.setIcon(building.getIcon());
        dto.setSummary(building.getSummary());
        dto.setMemories(building.getMemories().stream().map(this::toMemoryDto).collect(Collectors.toList()));
        return dto;
    }

    private MemoryDto toMemoryDto(MemoryRecord record) {
        MemoryDto dto = new MemoryDto();
        dto.setId(record.getId());
        if (record.getBuilding() != null) {
            dto.setBuildingId(record.getBuilding().getId());
        }
        dto.setTitle(record.getTitle());
        dto.setHappenedAt(record.getHappenedAt() == null ? "" : record.getHappenedAt().toString());
        dto.setWeather(record.getWeather());
        dto.setMediaTypes(split(record.getMediaTypes()));
        dto.setEmotions(split(record.getEmotions()));
        dto.setContent(record.getContent());
        if (record.getBuilding() != null) {
            dto.setBuildingName(record.getBuilding().getName());
            dto.setBuildingType(record.getBuilding().getType());
            dto.setBuildingIcon(record.getBuilding().getIcon());
        }
        dto.setExcerpt(excerpt(record.getContent()));
        dto.setComments(record.getComments().stream()
                .map(this::toCommentDto)
                .collect(Collectors.toList()));
        return dto;
    }

    private BottleDto toBottleDto(BottleMessage bottle) {
        BottleDto dto = new BottleDto();
        dto.setId(bottle.getId());
        dto.setSenderIsland(bottle.getSenderIsland());
        dto.setMood(bottle.getMood());
        dto.setMoodLabel(bottle.getMoodLabel());
        dto.setContent(bottle.getContent());
        return dto;
    }

    private SharedCollectionDto toCollectionDto(SharedCollection collection) {
        SharedCollectionDto dto = new SharedCollectionDto();
        dto.setId(collection.getId());
        dto.setName(collection.getName());
        dto.setMembers(split(collection.getMembers()));
        dto.setSummary(collection.getSummary());
        dto.setItems(split(collection.getItems()));
        return dto;
    }

    private List<String> split(String source) {
        if (source == null || source.trim().isEmpty()) {
            return Collections.emptyList();
        }
        return Arrays.stream(source.split(","))
                .map(String::trim)
                .filter(item -> !item.isEmpty())
                .collect(Collectors.toList());
    }

    private String moodLabel(String mood) {
        Map<String, String> moodMap = new HashMap<>();
        moodMap.put("calm", "平静");
        moodMap.put("happy", "轻快");
        moodMap.put("nostalgia", "怀念");
        moodMap.put("lonely", "孤单");
        return moodMap.getOrDefault(mood, "未知");
    }

    private CommentDto toCommentDto(MemoryComment comment) {
        CommentDto dto = new CommentDto();
        dto.setId(comment.getId());
        dto.setAuthorName(comment.getAuthorName());
        dto.setContent(comment.getContent());
        dto.setCreatedAt(comment.getCreatedAt() == null ? "" : comment.getCreatedAt().toString());
        return dto;
    }

    private void applyBuilding(Building building, UpsertBuildingRequest request) {
        building.setName(request.getName());
        building.setType(request.getType());
        building.setIcon(request.getIcon());
        building.setSummary(request.getSummary());
    }

    private void applyMemory(MemoryRecord record, Building building, CreateMemoryRequest request) {
        record.setBuilding(building);
        record.setTitle(request.getTitle());
        record.setHappenedAt(LocalDate.parse(request.getHappenedAt()));
        record.setWeather(request.getWeather() == null || request.getWeather().trim().isEmpty()
                ? "此刻写下"
                : request.getWeather().trim());
        record.setMediaTypes(request.getMediaType());
        record.setEmotions(request.getEmotions() == null || request.getEmotions().trim().isEmpty()
                ? "怀念,新记录"
                : request.getEmotions().trim());
        record.setContent(request.getContent());
    }

    private String excerpt(String content) {
        if (content == null || content.trim().isEmpty()) {
            return "";
        }
        String normalized = content.trim().replaceAll("\\s+", " ");
        return normalized.length() > 84 ? normalized.substring(0, 84) + "…" : normalized;
    }
}
