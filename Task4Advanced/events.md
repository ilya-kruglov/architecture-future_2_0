# Каталог доменных событий

| Событие | Контекст-источник | Семантика | Минимальный контракт |
|---------|-------------------|-----------|---------------------|
| **PatientRegistered** | Клиники | Пациент успешно зарегистрирован в системе | `{ patientId: UUID, fullName: string, birthDate: date, email: string, phone: string, registeredAt: timestamp }` |
| **PatientUpdated** | Клиники | Данные пациента обновлены | `{ patientId: UUID, changes: map, updatedBy: string, updatedAt: timestamp }` |
| **PatientDeactivated** | Клиники | Пациент деактивирован (например, уехал) | `{ patientId: UUID, reason: string, deactivatedAt: timestamp }` |
| **AppointmentCreated** | Клиники | Создана запись на приём | `{ appointmentId: UUID, patientId: UUID, doctorId: UUID, dateTime: timestamp, specialty: string, status: "SCHEDULED" }` |
| **AppointmentStarted** | Клиники | Начался приём | `{ appointmentId: UUID, startedAt: timestamp }` |
| **AppointmentCompleted** | Клиники | Приём завершён, поставлен диагноз | `{ appointmentId: UUID, diagnosis: string, prescription: string, completedAt: timestamp }` |
| **AppointmentCancelled** | Клиники | Приём отменён | `{ appointmentId: UUID, reason: string, cancelledAt: timestamp }` |
| **ExaminationOrdered** | Клиники | Назначено исследование | `{ examinationId: UUID, patientId: UUID, type: string, priority: string, orderedAt: timestamp }` |
| **ExaminationStarted** | Клиники | Исследование начато | `{ examinationId: UUID, startedAt: timestamp, operator: string }` |
| **ExaminationCompleted** | Клиники | Исследование выполнено | `{ examinationId: UUID, completedAt: timestamp, status: "DONE" }` |
| **ExaminationResultConfirmed** | Клиники | Результат исследования подтверждён врачом | `{ examinationId: UUID, result: string, confirmedBy: string, confirmedAt: timestamp }` |
| **AIDiagnosisRequested** | ИИ-сервисы | Запрошена ИИ-диагностика | `{ diagnosisId: UUID, patientId: UUID, examinationId: UUID, imageUrls: [string], requestedAt: timestamp }` |
| **AIDiagnosisCompleted** | ИИ-сервисы | ИИ-диагностика завершена | `{ diagnosisId: UUID, result: string, confidence: float, recommendations: [string], completedAt: timestamp }` |
| **AIDiagnosisConfirmed** | Клиники | Результат ИИ подтверждён врачом | `{ diagnosisId: UUID, confirmedBy: string, confirmedAt: timestamp }` |
| **AIDiagnosisRejected** | Клиники | Результат ИИ отклонён врачом | `{ diagnosisId: UUID, rejectedBy: string, reason: string, rejectedAt: timestamp }` |
| **LoanApplied** | Финтех | Заявка на кредит подана | `{ loanId: UUID, clientId: UUID, amount: decimal, term: integer, purpose: string, appliedAt: timestamp }` |
| **LoanApproved** | Финтех | Кредит одобрен | `{ loanId: UUID, approvedAmount: decimal, rate: decimal, approvedBy: string, approvedAt: timestamp }` |
| **LoanActivated** | Финтех | Кредит активирован (деньги выданы) | `{ loanId: UUID, activatedAt: timestamp }` |
| **LoanPaymentMade** | Финтех | Совершён платёж по кредиту | `{ paymentId: UUID, loanId: UUID, amount: decimal, date: timestamp, status: "SUCCESS" }` |
| **LoanClosed** | Финтех | Кредит погашен | `{ loanId: UUID, closedAt: timestamp }` |
| **LoanDefaulted** | Финтех | Кредит просрочен | `{ loanId: UUID, defaultedAt: timestamp, overdueDays: int }` |
| **AccountOpened** | Финтех | Открыт счёт | `{ accountId: UUID, clientId: UUID, type: string, openedAt: timestamp }` |
| **AccountClosed** | Финтех | Счёт закрыт | `{ accountId: UUID, closedAt: timestamp, reason: string }` |
| **TransactionMade** | Финтех | Проведена транзакция | `{ transactionId: UUID, accountId: UUID, amount: decimal, type: string, date: timestamp }` |
| **AccountFrozen** | Финтех | Счёт заморожен | `{ accountId: UUID, frozenAt: timestamp, reason: string }` |
| **DataMartUpdated** | Аналитика | Витрина данных обновлена | `{ datamartId: UUID, datasets: [string], updatedAt: timestamp, size: int }` |
| **ReportGenerated** | Аналитика | Отчёт сформирован | `{ reportId: UUID, name: string, generatedAt: timestamp, format: string, url: string }` |
| **ReportScheduled** | Аналитика | Отчёт запланирован | `{ reportId: UUID, schedule: string, recipients: [string] }` |
| **ReportDelivered** | Аналитика | Отчёт доставлен получателям | `{ reportId: UUID, deliveredAt: timestamp, recipients: [string] }` |
