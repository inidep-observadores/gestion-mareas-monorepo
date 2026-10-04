import re

file_path = r"d:\Desarrollo\_INIDEP\OBS\Mareas\gestion-mareas-monorepo\app\frontend\src\modules\planificacion\components\SimuladorTimeline.vue"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# 1. Add readonly to props
content = content.replace(
    "  timeScale?: 'day' | 'month';",
    "  timeScale?: 'day' | 'month';\n  readonly?: boolean;"
)

# 2. Bind editable in options
content = re.sub(
    r"editable: {\s*updateTime: true,\s*updateGroup: true,\s*remove: true,\s*add: true,\s*overrideItems: false\s*},",
    "editable: props.readonly ? false : {\n      updateTime: true,\n      updateGroup: true,\n      remove: true,\n      add: true,\n      overrideItems: false\n    },",
    content
)

# 3. Add watch for readonly to update timeline options dynamically
watch_readonly = """
watch(() => props.readonly, (newVal) => {
  if (timelineInstance) {
    timelineInstance.setOptions({
      editable: newVal ? false : {
        updateTime: true,
        updateGroup: true,
        remove: true,
        add: true,
        overrideItems: false
      }
    });
  }
});
"""
# insert before initTimeline
content = content.replace("const initTimeline = () => {", watch_readonly + "\nconst initTimeline = () => {")

# 4. Disable doubleClick logic if readonly
content = content.replace(
    "  timelineInstance.on('doubleClick', (properties) => {",
    "  timelineInstance.on('doubleClick', (properties) => {\n    if (props.readonly) return;\n"
)

# 5. Disable drop over container
content = content.replace(
    "const handleDrop = (e: DragEvent) => {",
    "const handleDrop = (e: DragEvent) => {\n  if (props.readonly) return;\n"
)
content = content.replace(
    "const handleDragOver = (e: DragEvent) => {",
    "const handleDragOver = (e: DragEvent) => {\n  if (props.readonly) return;\n"
)


with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
