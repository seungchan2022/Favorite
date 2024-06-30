import Foundation

public struct TimeDiffFunctor {
  public static func diffTime(updateTime: String) -> String {
    updateTime.formattedTimeDifference
  }
}

// MARK: - TimeDifference

// 시간 차이를 나타내는 열거형
fileprivate enum TimeDifference {
  case years(Int)
  case months(Int)
  case weeks(Int)
  case days(Int)
  case hours(Int)
  case minutes(Int)
  case now // 현재 시간을 나타내는 케이스

  // MARK: Public

  // 각 케이스에 대한 설명을 반환하는 연산 프로퍼티
  fileprivate var description: String {
    switch self {
    case .years(let year):
      "\(year) year\(year > 1 ? "s" : "") ago"
    case .months(let month):
      "\(month) month\(month > 1 ? "s" : "") ago"
    case .weeks(let week):
      "\(week) week\(week > 1 ? "s" : "") ago"
    case .days(let day):
      "\(day) day\(day > 1 ? "s" : "") ago"
    case .hours(let hour):
      "\(hour) hour\(hour > 1 ? "s" : "") ago"
    case .minutes(let minute):
      "\(minute) minute\(minute > 1 ? "s" : "") ago"
    case .now:
      "Now"
    }
  }
}

extension String {
  fileprivate var formattedTimeDifference: String {
    let dateFormatter = ISO8601DateFormatter()
    guard let lastUpdate = dateFormatter.date(from: self) else { return "" }

    // 현재 시간 가져오기
    let now = Date()
    // 현재 시간과 주어진 날짜 간의 차이 계산
    let calendar = Calendar.current
    let componentList = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute], from: lastUpdate, to: now)

    // 시간 차이에 따라 적절한 TimeDifference 케이스를 반환
    switch componentList {
    // where절: 0인 경우에는 해당 케이스를 무시하고 다음 케이스로 진행하도록 하는 추가적인 필터 역할을 합니다. => 이걸 설정하지 않으면 1년 아래에 있는 모든 아이템이 0 year 로 표현됌 => 다음 case로 넘어가지 않음
    case let years where years.year ?? 0 > 0:
      return TimeDifference.years(years.year ?? .zero).description
    case let months where months.month ?? 0 > 0:
      return TimeDifference.months(months.month!).description
    case let weeks where weeks.weekOfYear ?? 0 > 0:
      return TimeDifference.weeks(weeks.weekOfYear ?? .zero).description
    case let days where days.day ?? 0 > 0:
      return TimeDifference.days(days.day ?? .zero).description
    case let hours where hours.hour ?? 0 > 0:
      return TimeDifference.hours(hours.hour ?? .zero).description
    case let minutes where minutes.minute ?? 0 > 0:
      return TimeDifference.minutes(minutes.minute ?? .zero).description
    default:
      return TimeDifference.now.description
    }
  }
}
