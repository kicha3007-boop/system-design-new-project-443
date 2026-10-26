-- История пассажира: WHERE passenger_id = $1 ORDER BY created_at DESC LIMIT 20.
-- Первое поле индекса совпадает с фильтром, второе с сортировкой, поэтому
-- база спускается к нужному пассажиру и читает первые 20 записей уже в
-- порядке ответа, без чтения всей таблицы и без сортировки.
-- Решение и замеры: design/adr/010-history-index.md.
-- IF NOT EXISTS делает повторный прогон миграций безопасным.
CREATE INDEX IF NOT EXISTS trips_passenger_created_idx
    ON trips (passenger_id, created_at DESC);
