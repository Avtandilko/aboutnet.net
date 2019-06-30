---
layout: post
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

Lead Time (если следовать одному из определений) - время от зарождения идеи до появления результата в production. У high performers это время примерно в 200 раз меньше, чем у low performers (2015 г.) благодаря, в том числе, следованию культурным паттернам.

Вводятся четыре метрики (по State Of Devops от DORA за 2018 год их уже 5), по которым можно оценить организации:

* Deployment frequency;
* Lead time;
* Failure rate;
* MTTR (mean time to recover).

Три типа организаций по Веструму:

* Pathological;
* Bureaucratic;
* Generative.

Рассматриваем два из них:

* Generative - открыты к эспериментам, ответственность делится на всех, коммуникации поощряются - типовые high performers.
* Pathological - ответственность четко определена, любыми силами стараются избежать ошибок, ищут "козлов отпущения" - типовые low performers.

#### 1.2. Understanding Improvement (Part II)

Нет единого определения того, что такое DevOps. Одно из наиболее удачных:
```
DevOps is a cultural and professional movement. (Adam Jacob, Chef)
```

Большое влияние на DevOps оказала концепция бережливого производства (Lean).

Learning fast (быстрая обучаемость?) - одна из ключевых основ DevOps.

**CAMS**:

* Culture (improvement);
* Automation (delivery);
* Measurement (learning);
* Sharing (collaboration).

Статья [What DevOps Means to Me](https://blog.chef.io/2010/07/16/what-devops-means-to-me/).

CAMS - про культуру непрерывного улучшения.

#### 1.3. Understanding Improvement (Part III)

Japan's Influence (Toyota Production Systems):

* Muda (waste) - про деятельность, которая не создает ценности для клиента (ручной труд vs автоматизация;
* Mura (flow) - про определение узких мест ("бутылочных горлышек") в системе, неравномерность выполнения работы;
* Muri (stress) - про повышенную или пониженную нагрузку в различные периоды времени;
* Kaizen (improvement) - про непрерывное совершенствование;
* Kata (form) - про формализацию перечисленного выше, превращение в "мышечную память".

Книги:

* The Phoenix Project;
* DevOps Handbook.

#### 1.4. Understanding Improvement (Part IV)

Книга - Jez Humble, "Continuous Delivery".

Принципы Continuous Delivery:

* Build quality in (покрытие тестами должно быть максимальным);
* Work in small batches;
* Automate repeatable tasks;
* Pursue continuous improvement;
* Everyone is responsible ("If you build it, you own it").

Антипаттерны Continuous Delivery:

* Incongruent testing and production environments;
* Testing takes too long;
* Manual regression and acceptance tests (any manual work);
* Long lead times;
* High technical debt;
* Slow and hard to change.

Паттерны Continuous Delivery:

* Everything starts in source control;
* Peer reviews (pull requests);
* Automate everything;
* TBD;
* "Done" means "Released";
* Stop the line (возможность остановить цифровой конвейер и сосредоточиться на устранении багов, или других причин, ломающих процесс).
