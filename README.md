# Сервис такси под нагрузкой

[![hexlet-check](https://github.com/kicha3007-boop/system-design-new-project-443/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/kicha3007-boop/system-design-new-project-443/actions)

Опишите границы и устройство готового сервиса такси, задайте измеримые
требования и проведите базовый замер. Затем ускорьте историю поездок
индексом и подтвердите эффект повторным опытом на тех же данных.

Учебный проект Хекслета: https://ru.hexlet.io/programs/system-design-new


## Стек

- Node.js 26 + TypeScript (сервис), PostgreSQL 18 + PostGIS, nginx (балансировщик), k6 (нагрузка), Docker Compose

## Установка

Нужны Docker с Compose и make (на Windows — Git Bash). Node.js на машине не нужен: зависимости ставятся внутри контейнера.

```bash
git clone https://github.com/kicha3007-boop/system-design-new-project-443.git
cd system-design-new-project-443
```

## Использование

```bash
docker compose build --no-cache
make up                                    # стенд: nginx, app, app2, db; миграции применяются в make setup
curl -i localhost:8080/health              # 200, заголовок x-instance: app или app2
make seed-large                            # 2 000 000 поездок, 10 000 пассажиров (около 2 минут)
make load PROFILE=mixed NAME=rerun         # k6, отчёт в reports/rerun.md и .json
make down                                  # остановить стенд и удалить данные
```

Если порт 8080 занят: `WEB_PORT=18080 make up`. Чтобы повторить базовый замер без индекса, нужна база без миграции `db/migrations/003-history-index.sql` (например, `DROP INDEX trips_passenger_created_idx;` в `make psql`), затем `make seed-large` и `make load PROFILE=mixed NAME=baseline-rerun`. Имена `baseline` и `after-index` заняты сданными отчётами: `make load` перезаписывает `reports/<NAME>.md`. На Windows GNU make может записать русскую шапку отчёта в неверной кодировке; числа в `reports/<NAME>.json` от этого не зависят.

Результаты: проектный документ [design.md](design.md), решение [design/adr/010-history-index.md](design/adr/010-history-index.md), замеры [reports/baseline.md](reports/baseline.md) и [reports/after-index.md](reports/after-index.md).

---

<details>
<summary>Автоматические тесты Хекслета</summary>

Тесты запускаются на каждый коммит. За запуск отвечает файл `.github/workflows/hexlet-check.yml` — не удаляйте и не переименовывайте ни его, ни репозиторий.

</details>

## О Хекслете

[Хекслет](https://ru.hexlet.io/) — школа программирования: авторские программы обучения с практикой, поддержкой наставников и реальными проектами, которые остаются в резюме. Этот репозиторий — один из таких проектов.
