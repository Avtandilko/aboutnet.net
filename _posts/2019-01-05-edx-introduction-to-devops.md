---
layout: Post
title: edX Introduction to DevOps
categories: DevOps
permalink: /edx-introduction-to-devops
---

Здесь будут храниться мои конспекты по курсу от edX ['Introduction to DevOps'](https://courses.edx.org/courses/course-v1:LinuxFoundationX+LFS161x+2T2016/course/).

<!---excerpt-break-->

## Chapter 1: Why Do DevOps?
### Section 1: Understanding Improvement
#### 1.1. Understanding Improvement (Part I)

Пример компании Knight Capital Group обанкротившейся из-за ошибки при деплое на production. Концепция pets vs cattle. В Knight Capital Group относились к серверам как к питомцам.

Классическая проблема - Iron Triangle с вершинами reliability (Ops), speed (Dev), cost. Можем выбрать любые два пункта, пожервтовав третьим. DevOps - позволяет решить эту проблему и увидеть, что можно совместить эти три фактора.

Lead Time (если следовать одноиму из определений) - время от зарождения идеи до появления результата в Production. У high performers это время примерно в 200 раз меньше, чем у low performers (2015 г.) благодаря, в том числе, следованию культурным паттернам.

Вообще - вводятся четыре метрики, по которым можно оценить организации:

* Deployment frequency;
* Lead time;
* Failure rate;
* MTTR (mean time to recover).

Три типа организаций по Веструму:

* Pathological;
* Bureaucratic;
* Generative.

Рассматриваем два из них:

* Generetive - открыты к эспериментам, ответственность делится на всех, коммуникации поощряются - типовые high performers.
* Pathological - ответственность четко определена, любыми силами стараются избежать ошибок, ищут козлов отпущения - типовые low performers.

## 1.2. Understanding Improvement (Part II)