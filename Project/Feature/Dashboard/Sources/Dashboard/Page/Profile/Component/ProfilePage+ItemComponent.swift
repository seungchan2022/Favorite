import SwiftUI
import DesignSystem
import Domain

extension ProfilePage {
  struct ItemComponent {
    let  viewState: ViewState
    //    let action: ()
  }
}

extension ProfilePage.ItemComponent {
  func formattedDateString(from dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    guard let date = dateFormatter.date(from: dateString) else { return "" }
    
    let displayFormatter = DateFormatter()
    displayFormatter.dateFormat = "MMM yyyy"
    return displayFormatter.string(from: date)
  }
}

extension ProfilePage.ItemComponent: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(spacing: 8) {
        RemoteImage(
          url: viewState.item.avatarUrl,
          placeholder: {
            Rectangle().fill(DesignSystemColor.palette(.gray(.lv100)).color)
          })
        .frame(width: 80, height: 80)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
        VStack(alignment: .leading, spacing: 4) {
          Text(viewState.item.loginName)
            .font(.system(size: 20, weight: .bold))
          
          // if/else를 해주지 않으면 해당 아이템이 없을때 위 loginName이 아래로 내려옴 (아이템이 없어도 항상 같은자리에 있기르 원함)
          if  let name = viewState.item.name {
            Text(name)
              .font(.system(size: 16))
              .foregroundStyle(DesignSystemColor.palette(.gray(.lv300)).color)
          } else {
            Text("")
              .font(.system(size: 16))
              .foregroundStyle(DesignSystemColor.palette(.gray(.lv300)).color)
          }
          
          HStack {
            if let location = viewState.item.location {
              Image(systemName: "mappin.and.ellipse")
                .resizable()
                .frame(width: 12, height: 12)
              
              Text(location)
                .font(.system(size: 16))
                .foregroundStyle(DesignSystemColor.palette(.gray(.lv300)).color)
            } else {
              Text("")
                .font(.system(size: 16))
                .foregroundStyle(DesignSystemColor.palette(.gray(.lv300)).color)
            }
          }
        }
      }
      
      Text(viewState.item.bio ?? "")
        .font(.system(size: 16))
        .foregroundStyle(DesignSystemColor.palette(.gray(.lv300)).color)
        .padding(.vertical, 8)
      
      GroupBox {
        VStack {
          HStack {
            VStack {
              HStack(spacing: 8) {
                Image(systemName: "folder")
                  .resizable()
                  .frame(width: 14, height: 14)
                
                Text("Public repos")
                  .font(.system(size: 16))
              }
              
              Text("\(viewState.item.repos)")
                .font(.system(size: 16))
            }
            
            Spacer()
            
            VStack {
              HStack(spacing: 8) {
                Image(systemName: "line.3.horizontal")
                  .resizable()
                  .frame(width: 14, height: 14)
                
                Text("Public gists")
                  .font(.system(size: 16))
              }
              
              Text("\(viewState.item.gists)")
                .font(.system(size: 16))
            }
          }
          .padding(.horizontal, 16)
          
          Button(action: { }) {
            Text("Github Profile")
              .font(.headline)
              .frame(width: 300)
          }
          .tint(.purple)
          .buttonStyle(.bordered)
          .controlSize(.large)
        }
      }
      .padding(.bottom, 12)
      .frame(maxWidth: .infinity)
      
      GroupBox {
        VStack {
          HStack {
            VStack {
              HStack(spacing: 8) {
                Image(systemName: "heart")
                  .resizable()
                  .frame(width: 14, height: 14)
                
                Text("Followers")
                  .font(.system(size: 16))
              }
              
              Text("\(viewState.item.followers)")
                .font(.system(size: 16))
            }
            
            Spacer()
            
            VStack {
              HStack(spacing: 8) {
                Image(systemName: "person.2")
                  .resizable()
                  .frame(width: 14, height: 14)
                
                Text("Public gists")
                  .font(.system(size: 16))
              }
              
              Text("\(viewState.item.following)")
                .font(.system(size: 16))
            }
          }
          .padding(.horizontal, 16)
          
          Button(action: { }) {
            Text("Get Followers")
              .font(.headline)
              .frame(width: 300)
          }
          .tint(.green)
          .buttonStyle(.bordered)
          .controlSize(.large)
        }
      }
      .padding(.bottom, 12)
      .frame(maxWidth: .infinity)
      
      
      Text("Github since \(formattedDateString(from: viewState.item.created))")
        .frame(maxWidth: .infinity, alignment: .center) // 추가
      
      Spacer()
    }
    .padding(.horizontal, 16)
    .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
  }
}

extension ProfilePage.ItemComponent {
  struct ViewState: Equatable {
    let item: GithubEntity.Profile.Item
  }
}


