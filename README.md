# ZCode
The open-source AI coding agent powered by a multi-agent system.

ZCode is a customized evolution of OpenCode designed to simplify complex programming tasks by coordinating multiple AI models (GPT, Claude, Gemini) to plan, write, and test code simultaneously.

## 🚀 كيفية التثبيت والتشغيل (How to Install & Run)

ZCode مبني على لغة Go، وطريقة تثبيته مشابهة تماماً لـ OpenCode.

### الطريقة الأولى: التثبيت السريع (السكريبت الجاهز)
إذا كنت تستخدم Mac أو Linux، يمكنك تثبيت ZCode مباشرة عبر سطر الأوامر:
```bash
curl -fsSL https://raw.githubusercontent.com/tkjij77-ctrl/ZCode/main/install | bash
```

### الطريقة الثانية: التثبيت من المصدر (للمطورين - يوصى بها)
بما أنك المطور الأساسي للمشروع، يُفضل أن تقوم بتشغيله من الكود المصدري لتتمكن من رؤية تعديلات "النماذج المتعددة":

1. تأكد من تثبيت [لغة Go](https://go.dev/dl/) على جهازك.
2. قم بنسخ المستودع الخاص بك:
```bash
git clone https://github.com/tkjij77-ctrl/ZCode.git
cd ZCode
```
3. قم بتشغيل المشروع:
```bash
go run main.go
```
4. لبناء المشروع وتحويله إلى برنامج تنفيذي (App):
```bash
go build -o zcode
./zcode
```

### 🧠 كيفية تشغيل "النماذج المتعددة" (Multi-Agent)
بمجرد فتح واجهة ZCode، اكتب في مربع المحادثة طلبك بصيغة مشروع، مثال:
> "أريد بناء مشروع متجر إلكتروني"

سيقوم **العقل المدبر (Manager)** تلقائياً بالآتي:
1. تعيين **Claude 3.5** كمخطط (Planner).
2. تعيين **GPT-4** كمبرمج (Coder).
3. تعيين **Gemini 1.5** كمراجع (Reviewer).

وسيظهر لك تقدم العمل في الواجهة (زر القوة والوضع سيوضحان لك سير العمل).
