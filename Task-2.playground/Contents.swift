import UIKit

// ============================================
// TASK: Refactor this code using
// - Classes vs Structs
// - Protocols
// - Closures
// - Enums
// - Extensions
// ============================================

// --- User & Notifications domain (all classes, type/priority as strings) ---
//Refactor: Add Enums
enum RoleType{
    case admin
    case member
    case guest
}

struct User {
    let id: String
    let name: String
    let email: String
    let role: RoleType  // "admin", "member", "guest"

    init(id: String, name: String, email: String, role: RoleType) {
        self.id = id
        self.name = name
        self.email = email
        self.role = role
    }

    func getRoleDisplayName() -> String {
//        if role == "admin" {
//            return "Administrator"
//        } else if role == "member" {
//            return "Member"
//        } else if role == "guest" {
//            return "Guest"
//        } else {
//            return "Unknown"
//        }
        switch role {
        case .admin:
           return "admin"
        case .member:
            return"member"
        case .guest:
            return"guest"
        }
        
    }

    func canManageUsers() -> Bool {
           return role == .admin
       }
   }
struct Notification {
    let id: String
    let title: String
    let body: String
    let type: String   // "email", "push", "sms"
    let priority: String  // "low", "medium", "high"
    let read: Bool

    init(id: String, title: String, body: String, type: String, priority: String, read: Bool) {
        self.id = id
        self.title = title
        self.body = body
        self.type = type
        self.priority = priority
        self.read = read
    }

    func getTypeLabel() -> String {
        if type == "email" {
            return "Email"
        } else if type == "push" {
            return "Push"
        } else if type == "sms" {
            return "SMS"
        } else {
            return "Other"
        }
    }

    func getPriorityLabel() -> String {
        if priority == "low" {
            return "Low"
        } else if priority == "medium" {
            return "Medium"
        } else if priority == "high" {
            return "High"
        } else {
            return "Unknown"
        }
    }

    func isUrgent() -> Bool {
        if priority == "high" {
            return true
        }
        return false
    }
}

struct NotificationPreference {
    let userId: String
    let type: String   // "email", "push", "sms"
    let enabled: Bool

    init(userId: String, type: String, enabled: Bool) {
        self.userId = userId
        self.type = type
        self.enabled = enabled
    }

    func getTypeLabel() -> String {
        if type == "email" {
            return "Email"
        } else if type == "push" {
            return "Push"
        } else if type == "sms" {
            return "SMS"
        } else {
            return "Other"
        }
    }
}

// --- Service with validation and formatting (repeated patterns) ---

class UserValidator {
    func validateUser(user: User) -> (Bool, String) {
        if user.name.isEmpty {
            return (false, "Name is required.")
        }
        if user.email.isEmpty {
            return (false, "Email is required.")
        }
//        if user.role != "admin" && user.role != "member" && user.role != "guest" {
//            return (false, "Invalid role.")
//        }
        return (true, "Valid")
    }
}

class NotificationFormatter {
    func formatNotification(notification: Notification) -> String {
        var text = "[" + notification.getTypeLabel() + "] "
        text = text + notification.title + "\n"
        text = text + notification.body + "\n"
        text = text + "Priority: " + notification.getPriorityLabel()
        return text
    }

    func formatUser(user: User) -> String {
        return user.name + " (" + user.email + ") - " + user.getRoleDisplayName()
    }
}

// --- Manager using callbacks instead of closures ---

class NotificationManager {
    var validator: UserValidator
    var formatter: NotificationFormatter

    init() {
        self.validator = UserValidator()
        self.formatter = NotificationFormatter()
    }

    func sendNotification(
        to user: User,
        notification: Notification,
        onSent: (String) -> Void,
        onError: (String) -> Void
    ) {
        let (valid, message) = validator.validateUser(user: user)
        if valid {
            let formatted = formatter.formatNotification(notification: notification)
            onSent("Sent to " + user.name + ": " + formatted)
        } else {
            onError(message)
        }
    }

    func getAllNotificationSummaries(notifications: [Notification]) -> String {
        var result = ""
        for i in 0..<notifications.count {
            let n = notifications[i]
            result = result + n.title + " (" + n.getPriorityLabel() + ")"
            if i < notifications.count - 1 {
                result = result + "\n"
            }
        }
        return result
    }
}

// --- Usage / Demo ---

let user = User(id: "U1", name: "Bob", email: "bob@example.com", role: .member)
let notification = Notification(id: "N1", title: "Reminder", body: "Meeting at 3pm", type: "push", priority: "high", read: false)

let manager = NotificationManager()
manager.sendNotification(
    to: user,
    notification: notification,
    onSent: { message in
        print("Success: " + message)
    },
    onError: { error in
        print("Error: " + error)
    }
)

print(user.getRoleDisplayName())
print("Can manage users: " + String(user.canManageUsers()))
print(notification.getTypeLabel() + " - " + notification.getPriorityLabel())
print("Is urgent: " + String(notification.isUrgent()))
