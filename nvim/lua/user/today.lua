-- today.lua (daily file per date)

local notes_dir = vim.fn.expand("~/Desktop/obs-v1/tasks/")

-- :Today command with full daily planner in a date-named file
local function insert_today()
  local date = os.date("%Y-%m-%d")
  local daily_file = notes_dir .. date .. "-daily.md"
  local today_header = "## " .. date

  -- Full daily planner template
  local template = string.format(
    [[%s

## 🧠 1. Focus Goal of the Day
- [ ] Main objective:


## 📱 2. Indie App Development
- [ ] Feature 1:
- [ ] Feature 2:
- [ ] Bug fixes:
- [ ] App Store tasks:


## 🤖 3. AI / ML Learning
**Today's learning topic:**  
- [ ] Watch/Read:
- [ ] Practice / Code:
- [ ] Notes:


## 💼 4. Client Web Dev Work
- [ ] Task 1:
- [ ] Task 2:
- [ ] Delivery notes:


## 📣 5. Marketing / Growth
- [ ] Social post / Tweet:
- [ ] Blog update:
- [ ] Share progress:
- [ ] Email / Outreach:


## 🧹 6. Personal Admin
- [ ] Finance:
- [ ] Planning:
- [ ] Errands:


## 🏃 7. Health & Habits
- [ ] Workout:
- [ ] Walk:
- [ ] Stretch:
- [ ] Water (8 glasses):
- [ ] Sleep hours:


## 📝 8. Notes / Journal
- What happened today?
- What did you learn?
- What to improve tomorrow?


## 🌟 9. End-of-Day Review
- [ ] Did I complete the focus goal?
- [ ] Win of the day:
- [ ] What slowed me down?
- [ ] Tomorrow’s top 1 goal:
]],
    today_header
  )

  -- If file exists, just open it
  if vim.fn.filereadable(daily_file) == 1 then
    vim.cmd("edit " .. daily_file)
    vim.cmd("/" .. today_header)
    return
  end

  -- Split template into lines and write file
  local lines = vim.split(template, "\n", { trimempty = false })
  vim.fn.writefile(lines, daily_file)
  vim.cmd("edit " .. daily_file)
  vim.cmd("/" .. today_header)
end

vim.api.nvim_create_user_command("Today", insert_today, {})

-- :TaskFile command
local function create_task_file()
  vim.ui.input({ prompt = "Enter task file name (without .md): " }, function(input)
    if not input or input == "" then
      print("No file name provided.")
      return
    end
    local filename = input:gsub("%s+", "_") .. ".md"
    local filepath = vim.fn.expand("~/Desktop/obs-v1/tasks/" .. filename)
    local today = os.date("%Y-%m-%d %H:%M")
    local title = "# " .. input
    local content = string.format("%s\n\nDate: %s\n\n", title, today)
    if vim.fn.filereadable(filepath) == 1 then
      print("File already exists: " .. filepath)
      vim.cmd("edit " .. filepath)
      return
    end
    vim.fn.writefile(vim.split(content, "\n", { trimempty = false }), filepath)
    vim.cmd("edit " .. filepath)
  end)
end

vim.api.nvim_create_user_command("NewTask", create_task_file, {})
