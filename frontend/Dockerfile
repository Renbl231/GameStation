# Первый этап: сборка фронтенда
FROM node:22-alpine AS builder

WORKDIR /app

# Копируем package.json и устанавливаем зависимости
COPY package*.json ./
RUN npm ci

# Копируем весь код и собираем проект
COPY . .
RUN npm run build

# Второй этап: Nginx для раздачи статики
FROM nginx:stable-alpine

# Копируем собранные файлы из первого этапа
COPY --from=builder /app/dist /usr/share/nginx/html

# Копируем кастомный конфиг Nginx (создадим позже)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]