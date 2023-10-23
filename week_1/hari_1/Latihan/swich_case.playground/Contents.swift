import Foundation

enum Days: String, CaseIterable {
    case sunday, monday, tuesday, wednesdey, thursday, friday, saturday
    
    func description() -> String {
        switch self {
        case .sunday, .saturday:
            return "Libur cuy"
        case .monday, .tuesday, .friday, .wednesdey:
            return "Hari kerja"
        default:
            return "Cuti gengs"
        }
    }
}

var namaHari: Days = Days.friday

print(namaHari)

print(Days.allCases.count)

// Iterable melalui all cases
for direction in Days.allCases{
    print(direction.description())
}


//
