

#!/usr/bin/env bash
# set -o pipefail
 set -e
# если аргумент начинается с #
# запускать . autocommit.sh \#go
if [ "$#" -ge 1 ] && [[ "$1" == \#* ]]; then
  tag_commit="$1"
else
  tag_commit=""
fi

pull_to_server="true"

if git diff --quiet && git diff --cached --quiet; then
  echo "⚠️  Нет изменений для коммита."
  exit 0
fi


git add -A

#last_hash=$(git log --oneline | head -1 | awk '{print $1}')

last_hash=$(git rev-parse --short HEAD)

echo "Введите примечание к коммиту (Enter = автокоммит):"
read -r commit_text

if [ -n "$commit_text" ]; then
  commit_message="${tag_commit} ${commit_text}"
else
  commit_message="${tag_commit} autocommit_${last_hash}"
fi

git commit -m "$commit_message"

echo "return code  $?"
chk=$(git log --oneline | head -2)

# echo "$chk"
echo "✅ Коммит создан: $chk"

if [ "$pull_to_server" = "true" ]; then
  echo "🚀 Автоотправка на сервер включена"
  answer="y"
else
  echo "Сделать отправку на гитхаб? y/n"
  read -r answer
  answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
fi

if [ "$answer" = "y" ] || [ "$answer" = "yes" ]; then
  git pull

  if [ $? -eq 0 ]; then
    git push
    echo "👍👍👍👍 Успешно отправлены изменения на сервер"
  else
    echo "❌ Ошибка при git pull"
    exit 1
  fi
elif [ "$answer" = "n" ] || [ "$answer" = "no" ]; then
  echo "🛑 Операция отменена."
  exit 0
else
  echo "Неверный ввод. Введите 'y' или 'n'."
  exit 1
fi
