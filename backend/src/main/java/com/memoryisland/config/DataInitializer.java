package com.memoryisland.config;

import com.memoryisland.entity.BottleMessage;
import com.memoryisland.entity.Building;
import com.memoryisland.entity.MemoryRecord;
import com.memoryisland.entity.SharedCollection;
import com.memoryisland.repository.BottleMessageRepository;
import com.memoryisland.repository.BuildingRepository;
import com.memoryisland.repository.SharedCollectionRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Configuration
public class DataInitializer {

    @Bean
    public CommandLineRunner initDemoData(BuildingRepository buildingRepository,
                                          BottleMessageRepository bottleMessageRepository,
                                          SharedCollectionRepository sharedCollectionRepository) {
        return args -> {
            if (buildingRepository.count() == 0) {
                Building childhood = new Building();
                childhood.setName("童年花房");
                childhood.setType("人生阶段");
                childhood.setIcon("🌱");
                childhood.setSummary("放那些气味很重、细节却快散掉的小时候片段。");

                MemoryRecord memory1 = new MemoryRecord();
                memory1.setBuilding(childhood);
                memory1.setTitle("夏天午睡后，听见风扇一直转");
                memory1.setHappenedAt(LocalDate.of(2008, 7, 12));
                memory1.setWeather("闷热午后");
                memory1.setEmotions("安心,钝钝的幸福");
                memory1.setMediaTypes("文字,语音");
                memory1.setContent("外婆家的竹席有一点凉，醒来时客厅没人，只有风扇在转，阳光把窗帘照得很白。");
                childhood.getMemories().add(memory1);

                MemoryRecord memory2 = new MemoryRecord();
                memory2.setBuilding(childhood);
                memory2.setTitle("第一次自己去小卖部");
                memory2.setHappenedAt(LocalDate.of(2009, 3, 4));
                memory2.setWeather("放学后");
                memory2.setEmotions("紧张,得意");
                memory2.setMediaTypes("文字,图片");
                memory2.setContent("手里一直攥着两块钱，来回确认口袋有没有破。");
                childhood.getMemories().add(memory2);

                Building school = new Building();
                school.setName("求学灯塔");
                school.setType("人生阶段");
                school.setIcon("🎓");
                school.setSummary("记录学校时期的人、考场、走廊和那个年纪的自我认识。");

                MemoryRecord memory3 = new MemoryRecord();
                memory3.setBuilding(school);
                memory3.setTitle("晚自习停电的十分钟");
                memory3.setHappenedAt(LocalDate.of(2016, 11, 18));
                memory3.setWeather("初冬晚风");
                memory3.setEmotions("松弛,想笑");
                memory3.setMediaTypes("文字");
                memory3.setContent("整层楼突然暗下来，走廊里全是压不住的笑声。");
                school.getMemories().add(memory3);

                Building travel = new Building();
                travel.setName("远行码头");
                travel.setType("关系圈子");
                travel.setIcon("🧭");
                travel.setSummary("存放旅行、迁移、离开和抵达，一切和路有关的时刻。");

                MemoryRecord memory4 = new MemoryRecord();
                memory4.setBuilding(travel);
                memory4.setTitle("凌晨四点的火车站");
                memory4.setHappenedAt(LocalDate.of(2021, 8, 26));
                memory4.setWeather("潮湿微凉");
                memory4.setEmotions("漂浮感,期待");
                memory4.setMediaTypes("文字,视频");
                memory4.setContent("站前广场灯很白，行李箱轮子一直卡在砖缝里。");
                travel.getMemories().add(memory4);

                buildingRepository.save(childhood);
                buildingRepository.save(school);
                buildingRepository.save(travel);
            }

            if (bottleMessageRepository.count() == 0) {
                BottleMessage bottle1 = new BottleMessage();
                bottle1.setSenderIsland("北岬岛");
                bottle1.setMood("nostalgia");
                bottle1.setMoodLabel("怀念");
                bottle1.setContent("今天突然想起奶奶晾衣服时夹子碰撞的声音。原来我记住的不是画面，是声音。");
                bottle1.setCreatedAt(LocalDateTime.now());

                BottleMessage bottle2 = new BottleMessage();
                bottle2.setSenderIsland("晴湾岛");
                bottle2.setMood("happy");
                bottle2.setMoodLabel("轻快");
                bottle2.setContent("刚翻到一张旧车票，发现那次临时起意的出门，后来成了我最喜欢的一年。");
                bottle2.setCreatedAt(LocalDateTime.now());

                bottleMessageRepository.save(bottle1);
                bottleMessageRepository.save(bottle2);
            }

            if (sharedCollectionRepository.count() == 0) {
                SharedCollection collection1 = new SharedCollection();
                collection1.setName("2019 海边夏夜");
                collection1.setMembers("阿宁,你");
                collection1.setSummary("把那次临时看海的片段拼回完整版本。");
                collection1.setItems("阿宁补充：到海边时鞋里已经进沙了,你补充：便利店买的是荔枝味汽水,待补：返程时广播里放的歌");

                SharedCollection collection2 = new SharedCollection();
                collection2.setName("大学宿舍碎片");
                collection2.setMembers("小周,你,阿禾");
                collection2.setSummary("不是大事，而是日后才会怀念的细节。");
                collection2.setItems("小周记得：有一次全宿舍一起在阳台吹风,阿禾记得：毕业前一晚谁都没睡");

                sharedCollectionRepository.save(collection1);
                sharedCollectionRepository.save(collection2);
            }
        };
    }
}
