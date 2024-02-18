import DesignSystem
import Domain
import SwiftUI

// MARK: - RepoPage.RepositoryItemComponent

extension RepoPage {
  struct RepositoryItemComponent {
    let viewState: ViewState
    let action: (GithubEntity.Search.Repository.Item) -> Void
  }
}

extension RepoPage.RepositoryItemComponent {
  private var isEmptyRankCount: Bool {
    (
      viewState.item.starCount
        + viewState.item.forkCount
        + viewState.item.watcherCount) == .zero
  }

  private func formattedTimeDifference(_ lastUpdateString: String) -> String {
    let dateFormatter = ISO8601DateFormatter()
    guard let lastUpdate = dateFormatter.date(from: lastUpdateString) else { return "" }

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

// MARK: - RepoPage.RepositoryItemComponent + View

extension RepoPage.RepositoryItemComponent: View {
  var body: some View {
    HStack(alignment: .top, spacing: 8) {
      RemoteImage(
        url: viewState.item.owner.avatarUrl,
        placeholder: {
          Rectangle()
            .fill(DesignSystemColor.palette(.gray(.lv100)).color)
        })
        .frame(width: 30, height: 30)
        .clipShape(Circle())

      VStack(alignment: .leading, spacing: 4) {
        Text(viewState.item.fullName)
          .font(.system(size: 14, weight: .bold))
          .foregroundStyle(DesignSystemColor.system(.black).color)

        if let desc = viewState.item.desc {
          Text(desc)
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(DesignSystemColor.system(.black).color)
        }

        if !isEmptyRankCount {
          HStack {
            if viewState.item.starCount > .zero {
              HStack(spacing: 4) {
                Image(systemName: "star")
                  .resizable()
                  .frame(width: 8, height: 8)

                Text("\(viewState.item.starCount)")
                  .font(.system(size: 8))
              }
            }

            if viewState.item.watcherCount > .zero {
              HStack(spacing: 4) {
                Image(systemName: "eye")
                  .resizable()
                  .frame(width: 8, height: 8)

                Text("\(viewState.item.watcherCount)")
                  .font(.system(size: 8))
              }
            }

            if viewState.item.forkCount > .zero {
              HStack(spacing: 4) {
                Image(systemName: "tuningfork")
                  .resizable()
                  .frame(width: 8, height: 8)

                Text("\(viewState.item.forkCount)")
                  .font(.system(size: 8))
              }
            }
          }
        }
      }

      Spacer()

      Text("\(formattedTimeDifference(viewState.item.lastUpdate))")
        .font(.system(size: 14))
    }

    .frame(minWidth: .zero, maxWidth: .infinity)
    .padding(16)

    .onTapGesture {
      action(viewState.item)
    }
  }
}

// MARK: - RepoPage.RepositoryItemComponent.ViewState

extension RepoPage.RepositoryItemComponent {
  struct ViewState: Equatable {
    let item: GithubEntity.Search.Repository.Item
  }
}

// MARK: - TimeDifference

// 시간 차이를 나타내는 열거형
enum TimeDifference {
  case years(Int)
  case months(Int)
  case weeks(Int)
  case days(Int)
  case hours(Int)
  case minutes(Int)
  case now // 현재 시간을 나타내는 케이스

  // MARK: Internal

  // 각 케이스에 대한 설명을 반환하는 연산 프로퍼티
  var description: String {
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
