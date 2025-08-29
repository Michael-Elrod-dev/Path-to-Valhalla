# Project Dashboard - Norse Mythology Roguelike

## Current Sprint Status

### High Priority Tasks
```dataview
TASK
FROM #combat OR #development OR #art OR #design OR #enemy-ai OR #level-design
WHERE !completed AND contains(text, "high") 
```

### Recently Completed
```dataview
TASK
FROM #combat OR #development OR #art OR #design OR #enemy-ai OR #level-design
WHERE completed
SORT completion DESC
LIMIT 10
```

## Epic Progress

### Active Epics
```dataview
TABLE 
  status, 
  priority,
  length(filter(file.tasks, (t) => t.completed)) + " / " + length(file.tasks) as "Tasks",
  round((length(filter(file.tasks, (t) => t.completed)) / length(file.tasks)) * 100) + "%" as "Progress"
FROM #epic
WHERE status != "completed" AND !contains(file.name, "Template")
```


## Development Areas

### Combat System
```dataview
TASK
FROM #combat
WHERE !completed AND text != "" AND text != " "
```

### Art & Design
```dataview
TASK
FROM #art OR #design
WHERE !completed AND text != "" AND text != " "
```

### Enemy AI & Level Design
```dataview
TASK
FROM #enemy-ai OR #level-design
WHERE !completed AND text != "" AND text != " "
```

### Systems & Infrastructure
```dataview
TASK
FROM #development
WHERE !completed AND text != "" AND text != " "
```
