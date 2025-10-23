# Slack Async Standup Template

## Настройка канала (скопируйте в Slack)

### 1. Создайте канал
```
/create #daily-standup
```

### 2. Добавьте описание канала
```
📅 Daily async standup updates

Format:
✅ Yesterday: what you completed
🎯 Today: what you're working on  
🚧 Blockers: anything blocking you

Post by 10am your time ⏰
```

### 3. Настройте напоминание
```
/remind #daily-standup "⏰ Daily standup time! Post your update using the template 👇" every weekday at 9:00 AM
```

---

## Шаблон для копирования в Slack

### Вариант 1: Простой (рекомендуется)
```
📅 [Дата] - [Имя]

✅ Yesterday:
- 
- 
- 

🎯 Today:
- 
- 

🚧 Blockers:
- 

Status: 🟢 / 🟡 / 🔴
```

### Вариант 2: С деталями
```
📅 [Дата] - [Имя]

✅ Completed:
- Task 1 (link to PR/issue)
- Task 2 (link to PR/issue)

🎯 In Progress:
- Task 3 (expected completion: date)
- Task 4

📋 Planned:
- Task 5
- Task 6

🚧 Blockers:
- None / [описание блокера]

💭 Notes:
- Any FYIs for the team

🎭 Mood: 😊 / 😐 / 😓
```

### Вариант 3: С процентами прогресса
```
📅 [Дата] - [Имя]

🎯 Main Focus Today: [Главная задача]

Progress Yesterday:
- Feature X: ████████░░ 80%
- Bug fixes: ██████████ 100% ✅
- Documentation: ████░░░░░░ 40%

Today's Goals:
1. [Цель 1]
2. [Цель 2]
3. [Цель 3]

⚠️ Blockers: [None / описание]

Status: 🟢
```

---

## Примеры реальных постов

### Пример 1: Обычный день (все хорошо)
```
📅 Oct 23 - Sergey

✅ Yesterday:
- Implemented user auth API (PR #234) ✅
- Fixed bug in payment flow (#145)
- Code review for @maria's UI components PR

🎯 Today:
- Stripe payment integration (issue #240)
- Write tests for auth API
- Deploy to staging environment

🚧 Blockers:
- None! 🎉

Status: 🟢
```

### Пример 2: С блокером
```
📅 Oct 23 - Maria

✅ Yesterday:
- Designed new dashboard mockups
- Updated component library docs
- Fixed 3 CSS bugs from QA

🎯 Today:
- Implementing dashboard (PR #241)
- Need feedback on design from @alex

🚧 Blockers:
- ⚠️ Waiting for API endpoint from backend team (requested Mon, need by Thu)
- Missing design assets for mobile view

Status: 🟡

@backend-team @design-team 👆
```

### Пример 3: Работа над большой задачей
```
📅 Oct 23 - Alex

✅ Yesterday:
- Payment integration: ████████░░ 80%
  - Setup complete ✅
  - Webhooks implemented ✅
  - Testing pending

🎯 Today:
- Finish payment integration testing
- Handle edge cases (refunds, disputes)
- Code review & deploy

🚧 Blockers:
- None, on track for Friday release

Status: 🟢

ETA: Payment feature live by EOD Friday 🎯
```

### Пример 4: Sick day / Out of Office
```
📅 Oct 23 - Sergey

🤒 Sick today, taking the day off

📋 Coverage:
- @maria can handle any urgent issues with auth API
- Will catch up on PRs tomorrow

Status: 🏥
```

### Пример 5: Множество мелких задач
```
📅 Oct 23 - Alex

✅ Yesterday:
- 🐛 Fixed 5 bugs from QA (#142, #143, #145, #146, #147)
- 📝 Updated documentation
- 👀 Reviewed 3 PRs

🎯 Today:
- Continue bug bash (7 bugs remaining)
- Investigate performance issue in dashboard
- Team retro at 2pm

🚧 Blockers:
- None

Status: 🟢

Note: Bug count down from 15 → 10 this week! 📉
```

---

## Slack Workflow Builder (автоматизация)

### Создайте кастомный workflow:

1. Откройте Slack → Tools → Workflow Builder
2. Create Workflow → "Daily Standup"
3. Trigger: Shortcut (назовите "Post Standup")
4. Steps:
   - Send a message to #daily-standup
   - Use form responses

### Форма:
```
Fields:
- Your name (short text)
- Yesterday accomplishments (long text)
- Today's plans (long text)
- Blockers (long text, optional)
- Status (single select: 🟢 Good / 🟡 Blockers / 🔴 Need Help)
```

### Output format:
```
📅 {{date}} - {{name}}

✅ Yesterday:
{{yesterday}}

🎯 Today:
{{today}}

🚧 Blockers:
{{blockers}}

Status: {{status}}
```

Теперь каждый может нажать ⚡ shortcuts → "Post Standup" и заполнить форму!

---

## Автоматические напоминания (advanced)

### Напоминание с проверкой кто не постил:

Используйте Geekbot или создайте simple bot:

```javascript
// slack-standup-reminder.js
// Запускать через cron каждый день в 10:30

const { WebClient } = require('@slack/web-api');
const client = new WebClient(process.env.SLACK_TOKEN);

async function checkStandups() {
  const channel = 'C0123456789'; // #daily-standup channel ID
  const today = new Date().toISOString().split('T')[0];
  
  // Получить все сообщения за сегодня
  const messages = await client.conversations.history({
    channel: channel,
    oldest: todayMidnight,
  });
  
  // Получить всех участников канала
  const members = await client.conversations.members({ channel });
  
  // Найти кто не постил
  const posted = messages.messages.map(m => m.user);
  const notPosted = members.filter(m => !posted.includes(m));
  
  // Отправить приватное напоминание
  for (const user of notPosted) {
    await client.chat.postMessage({
      channel: user,
      text: '👋 Friendly reminder: Daily standup update not posted yet!',
    });
  }
}

checkStandups();
```

---

## Status Emoji Legend (добавьте в описание канала)

```
🟢 All good, no blockers
🟡 Some challenges but making progress
🔴 Blocked, need help urgently
🏖️ Out of office / PTO
🤒 Sick day
🏠 Working from home (if normally in office)
✈️ Traveling
🎓 Learning day / Training
🔧 Maintenance / Tech debt day
```

---

## Tips для команды

### ✅ Best practices:

1. **Постите в одно время** (создаёт привычку)
   - Рекомендация: начало дня (9-10am) или конец дня (5-6pm)

2. **Используйте links**
   ```
   ✅ "Working on issue #240"
   ✅ "Merged PR #234 (link)"
   ❌ "Working on that bug" (неконкретно)
   ```

3. **Тегайте людей при необходимости**
   ```
   🚧 Blockers:
   - @devops need AWS access for deployment
   - @design waiting for mobile mockups
   ```

4. **Один пост = один день** (не редактируйте старые)

5. **Реагируйте emoji на посты коллег** (показывает что читаете)
   ```
   👍 - seen
   🎉 - congrats on completion
   💪 - support for blockers
   👀 - will look into it
   ```

### ❌ Избегайте:

1. **Слишком подробно**
   ```
   ❌ 500 слов о том как решали проблему
   ✅ "Fixed bug X, details in PR #234"
   ```

2. **Слишком кратко**
   ```
   ❌ "Working on stuff"
   ✅ "Implementing payment API integration"
   ```

3. **Пропуски без объяснения**
   ```
   ❌ Молчание 2 дня
   ✅ "OOO today, back tomorrow"
   ```

---

## Weekly Summary Template (пятница)

Один человек (ротация каждую неделю) постит summary:

```
📊 Week [#] Summary ([dates])

👥 Team Stats:
- ✅ Completed: [X] tasks
- 🚀 Deployed: [X] features
- 🐛 Bugs fixed: [X]
- 📝 PRs merged: [X]

🏆 Highlights:
- [Major achievement 1]
- [Major achievement 2]
- [Major achievement 3]

🚧 Active Blockers:
- [Blocker 1] - @owner
- [Blocker 2] - @owner

📅 Next Week Focus:
- [Priority 1]
- [Priority 2]

Great work team! 🎉
Have a great weekend! 🌴
```

---

## Integrations (опционально)

### GitHub PR автоматически в standup:
```
Используйте GitHub Slack integration:
/github subscribe owner/repo pulls

Настройте чтобы merged PRs постились в #daily-standup
```

### Jira/Linear updates:
```
Linear: Settings → Integrations → Slack
Настройте чтобы completed issues постились в канал
```

### Calendar integration:
```
Google Calendar → Slack
Out of office events автоматически постятся
```

---

## Troubleshooting

**Проблема: Люди забывают постить**
- Решение 1: Slack reminder в 9am
- Решение 2: Peer pressure (team culture)
- Решение 3: Geekbot автоматически спрашивает

**Проблема: Посты слишком длинные**
- Решение: Установите лимит (макс 5 bullet points)

**Проблема: Никто не читает посты других**
- Решение: Тимлид делает summary и тегает людей
- Решение 2: Weekly highlights post

**Проблема: Дублирование с project management tools**
- Решение: Standup = high-level, детали в Jira/Linear
- Или интегрируйте tools (автопост из Jira)

---

**Ready to start? Скопируйте шаблон в Slack и начинайте! 🚀**

