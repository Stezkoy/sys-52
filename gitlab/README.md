# Домашнее задание к занятию "`GitLab`" - `Александр Сергеевич М`

---

### Задание 1
**Что нужно сделать:**

1. Разверните GitLab локально, используя Vagrantfile и инструкцию, описанные в [этом репозитории](https://github.com/netology-code/sdvps-materials/tree/main/gitlab).   
2. Создайте новый проект и пустой репозиторий в нём.
3. Зарегистрируйте gitlab-runner для этого проекта и запустите его в режиме Docker. Раннер можно регистрировать и запускать на той же виртуальной машине, на которой запущен GitLab.

В качестве ответа в репозиторий шаблона с решением добавьте скриншоты с настройками раннера в проекте.



![runner_git](img/runner_git.png)

![runner_git](img/runner_git2.png)

![runner_git](img/runner_docker.png)


---

### Задание 2

**Что нужно сделать:**

1. Запушьте [репозиторий](https://github.com/netology-code/sdvps-materials/tree/main/gitlab) на GitLab, изменив origin. Это изучалось на занятии по Git.
2. Создайте .gitlab-ci.yml, описав в нём все необходимые, на ваш взгляд, этапы.

В качестве ответа в шаблон с решением добавьте: 
   
 * файл gitlab-ci.yml для своего проекта или вставьте код в соответствующее поле в шаблоне; 
 * скриншоты с успешно собранными сборками.

```
stages:
  - test
  - build

test:
  stage: test
  image: golang:1.17
  script: 
   - go test .
  tags:
   - netology

build:
  stage: build
  image: docker:latest
  script:
   - docker build .
  tags:
   - netology
```

![gitlab_push](img/gitlab_push.png)

![gitlab_runner](img/gitlab_runner.png)



---

## Дополнительные задания* (со звёздочкой)

Их выполнение необязательное и не влияет на получение зачёта по домашнему заданию. Можете их решить, если хотите лучше разобраться в материале.

---

### Задание 3*

Измените CI так, чтобы:

 - этап сборки запускался сразу, не дожидаясь результатов тестов;
 - тесты запускались только при изменении файлов с расширением *.go.

В качестве ответа добавьте в шаблон с решением файл gitlab-ci.yml своего проекта или вставьте код в соответсвующее поле в шаблоне.

```
stages:
  - test
  - build

test:
  stage: test
  image: golang:1.17
  script:
    - go test .
  tags:
    - netology
  rules:
    - changes:
      - "*.go"

build:
  stage: build
  image: docker:latest
  script:
    - docker build .
  tags:
    - netology
  needs: []
```

![test](img/rules.png)