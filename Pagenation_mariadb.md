
# Pagenation - MariaDB

## limit

```txt
MariaDB / MySQL 에서 페이징 처리를 위해서는 
select 의 마지막 부분에 limit 처리를 이용한다.
limit 뒤에는 하나 혹은 두 개의 값을 전달하는데 데이터의 수에 따라서
다음과 같은 의미를 가진다.
```

```txt
- select * from tbl_todo order by tno desc limit 10;
  여기에서 10은 가져오는 데이터의 수

- select * from tbl_todo order by tno desc limit 10, 10;
  여기에서 첫번째 10은 건너뛰는 데이터의 수
  두번째 10은 가져오는 데이터의 수
```

## limit 의 단점

limit가 상당히 편리한 페이징 처리 기능을 제공하지만 limit 뒤에 식(expression)은 사용이 불가능하고
오직 값만을 주어야 한다는 단점이 존재한다.

## count()의 필요성

페이징 처리를 하기 위해서는 전체 데이터의 개수도 필요하다.
전체 데이터의 개수는 페이지 번호를 구성할 때 필요하다.
예를 들어 데이터가 30개면 3페이지까지만 출력해야 하는 작업에서 사용된다.

```txt
select count(tno) from tbl_todo;
```

---

## 페이지 처리를 위한 DTO

페이지 처리는 현재 페이지의 번호(page), 한 페이지당 보여주는 데이터의 수(size)가 기본적으로 필요하다.
2개의 숫자를 매번 전달할 수도 있겠지만 나중에 확장 여부를 고려해서라도 별도의 DTO로 만들어 두는 것이 좋다

```java
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
public class PageRequestDTO {

	@Builder.Default // 인스턴스를 만들때 특정 필드를 특정 값으로 초기화하고 싶다면
	@Min(value = 1)
	@Positive // 양수만 가능
	private int page = 1;
	
	@Builder.Default
	@Min(value = 10)
	@Max(value = 100)
	@Positive
	private int size = 10;
	
	public int getSkip() {
		return (page -1) * 10;
	}
}
```

PageRequestDTO 는 페이지 번호 (page)와 한  페이지당 개수(size)를 보관하는 용도 외에도 limit에서
사용하는 건너뛰기(skip)의 수를 getSkip()을 만들어서 사용한다.

page나 size는 기본값을 가지기 위해서 Lombok의 @Builder.Default를 이용한다.
@Min, @Max를 이용해서 외부에서 조작하는 것에 대해서도 대비하도록 구성한다.

## TodoMapper의 목록 처리

MyBatis를 사용중이라면 Mapper 인터페이스에 PageRequestDTO를 파라미터로 처리하는 selectList()를 추가한다.

```java
public interface TodoMapper {

	List<TodoVO> selectList(PageRequestDTO pageReqeustDTO);
}
```

그리고 TodoMapper.xml 내에서 selectList는 다음과 같이 구현한다.

```xml
<select id="selectList" resultType="com.rio.base.domain.TodoVo">
	select * from tbl_todo order by tno desc limit #{skip}, #{size}
</select>
```

MyBatis는 기본적으로 getXXX, setXXX를 통해서 동작하기 때문에 #{skip}의 경우는 getSkip()을 호출하게 된다.

테스트코드를 이용해서 Mapper의 selectList()가 정상적으로 동작하는지 확인해보자.

```java
@Test
public void testSelectList() {

	PageRequestDTO pageRequestDTO = PageRequestDTO.builder()
					.page(1)
					.size(10)
					.build();

	List<TodoVO> voList = todoMapper.selectList(pageRequestDTO);

	voList.forEach(vo -> log.info(vo));
	
}
```

![스크린샷 2023-06-12 오후 2 34 37](https://github.com/ParkRio/MegaKGCoffee/assets/96435200/9a2ded74-f0b3-4eb6-9525-ea50a6ba9db4)


## TodoMapper의 count 처리

화면에 페이지 번호들을 구성하기 위해서는 전체 데이터의 수를 알아야만 가능하다.
예를 들어 마지막 페이지가 7에서 끝나야 하는 상황이 생긴다면 화면상에도 페이지 번호를 조정해야 하기 때문이다.

Mapper 인터페이스에 getCount()를 추가하자.
getCount()는 나중에 검색을 대비해서 PageRequestDTO를 파라미터로 받도록 설계한다.

```java
public interface TodoMapper {

	...

	int getCount(PageRequestDTO pageRequestDTO);
}
```

Mapper.xml은 우선 전체 개수를 반환하도록 구성하자.

```xml
<select id="getCount" resultType="int">
	select count(tno) from tbl_todo
</select>
```

---

## 목록 데이터를 위한 DTO와 서비스 계층

TodoMapper에서 TodoVO의 목록과 전체 데이터의 수를 가져온다면 이를 서비스 계층에서
한 번에 담아서 처리하도록 DTO를 구성하는 것이 좋다.

작성하려는 DTO는 PageResponseDTO 라는 이름으로 생성하고
다음과 같은 데이터와 기능을 가지도록 구성한다.

```txt
- TodoDTO의 목록
- 전체 데이터의 수
- 페이지 번호의 처리를 위한 데이터들 (시작 페이지 번호 / 끝 페이지 번호)
```

화면상에서 페이지 번호들을 출력하려면 현재 페이지 번호(page)와 페이지당 데이터의 수(size)를 이용해서 계산할 필요가 있다.

이 때문에 pageResponseDTO는 생성자를 통해서 필요한 page 나 size를 전달받도록 구성해야 한다.

```java
public class PageRequestDTO<E> {

	private int page;
	private int size;
	private int total;

	// 시작 페이지 번호
	private int start;

	// 끝 페이지 번호
	private int end;

	// 이전 페이지의 존재 여부
	private boolean prev;

	// 다음 페이지의 존재 여부
	private boolean next;

	private List<E> dtoList;
}
```

PageResponseDTO는 제네릭을 이용해서 설계한다.
제네릭을 이용하는 이유는 나중에 다른 종류의 객체를 이용해서 PageResponseDTO를
구성할 수 있도록 하기 위해서이다.

예를 들어 게시판이나 회원 정보 등도 페이징 처리가 필요할 수 있기 때문에
공통적인 처리를 위해서 제네릭으로 구성한다.

**PageResponseDTO는 여러 정보를 생성자를 이용해 받아서 처리하는 것이 안전하다.**

예를 들어 PageRequestDTO에 있는 page, size 값이 필요하고, TodoDTO 목록 데이터와
전체 데이터의 개수고 필요하다.

PageResponseDTO의 생성자는 Lombok의 @Builder를 적용한다.

```java
@Builder(builderMethodName = "withAll")
public PageResponseDTO(PageRequestDTO pageRequestDTO, List<E> dtoList, int total) {

	this.page = pageRequestDTO.getPage();
	this.size = pageRequestDTO.getSize();

	this.total = total;
	this.dtoList = dtoList;
}
```

![스크린샷 2023-06-12 오후 3 04 04](https://github.com/ParkRio/MegaKGCoffee/assets/96435200/42a5d747-8cdc-4cc6-8e40-9e0d2548427d)

---

## 페이지 번호의 계산

페이지 번호를 계산하려면 우선 현재 페이지의 번호(page)가 필요하다.
화면에 10개의 페이지 번호를 출력한다고 했을 때 다음과 같은 경우들이 생길 수 있다.

```txt
- page가 1인 경우 : 시작 페이지 (start)는 1, 마지막 페이지는 (end)는 10
- page가 10인 경우 : 시작 페이지 (start)는 1, 마지막 페이지는 (end)는 10
- page가 11인 경우 : 시작 페이지 (start)는 11, 마지막 페이지 (end)는 20
```

- **마지막 페이지 / 시작 페이지 번호의 계산**
  흔히들 처음에 구해야 하는 것이 start라고 생각하지만, 마지막 페이지 (end)를 구하는 계산이 더 편할 수 있다.
  end는 현재의 페이지 번호를 기준으로 계산한다.
  
```txt
this.end = (int)(Math.ceil(this.page / 10.0)) * 10;

Page를 10으로 나눈 값을 올림 처리 한후 * 10
1 / 10.0 => 0.1 => 1 => 10
11 / 10.0 => 1.1 => 2 => 20
10 / 10 => 1.0 => 1 => 10
```

마지막 페이지를 먼저 계산하는 진짜 이유는 시작 페이지(start)의 계산을 쉽게 하기 위함이다.
시작 페이지(start)의 경우 계산한 마지막 페이지에서 9를 빼면 되기 때문이다.

```txt
this.start = this.end - 9;
```

시작 페이지의 구성은 끝났지만 마지막 페이지의 경우 다시 전체 개수(total)을 고려해야 한다.
만일 10개씩(size) 보여주는 경우 전체 개수(total)가 75라면
마지막 페이지는 10이 아닌 8이 되어야 하기 때문이다.

```txt
int last = (int)(Math.ceil((total/(double)size)));

123 / 10.0 => 12.3 => 13
100 / 10.0 => 10.0 => 10
75 / 10.0 => 7.5 => 8
```

마지막 페이지(end)는 앞에서 구한 last 값보다 작은 경우에 last 값이 end가 되어야만 한다.

```txt
this.end = end > last ? last : end;
```

## 이전(prev) / 다음 (next)의 계산

이전 페이지의 존재 여부는 시작 페이지(start)가 1이 아니라면 무조건 true가 되어야 한다.
다음(next)은 마지막 페이지(end)와 페이지당 개수(size)를 곱한 값보다 전체 개수(total)가
더 많은지를 보고 판단한다.

```txt
this.prev = this.start > 1;
this.next = total > this.end * this.size;
```

PageResponseDTO는 최종적으로 Lombok의 @Getter를 적용해서 다음과 같은 형태가 된다.

```java
@Builder(builderMethodName = "withAll")

public PageResponseDTO(PageRequestDTO pageRequestDTO, List<E> dtoList, int total) {

	this.page = pageRequestDTO.getPage();
	
	this.size = pageRequestDTO.getSize();
	
	this.total = total;
	
	this.dtoList = dtoList;
	
	this.end = (int)(Math._ceil_(this.page/ 10.0)) * 10;
	
	this.start = this.end - 9;
	
	int last = (int)(Math._ceil_(total/(double)size));
	
	this.end = end > last ? last: end;
	
	this.prev = this.start > 1;
	
	this.next = total > this.end * this.size;

}
```

## TodoService / TodoServiceImpl

Service와 ServiceImpl 에서는 작성된 PageResponseDTO를 반환 타입으로 지정해서
getList()를 구성한다. (기존의 getAll()을 대체)

```java
public interface TodoService {

	void register(TodoDTO todoDTO);

	//List<TodoDTO> getAll();

	PageResponseDTO<todoDTO> getList(PageRequestDTO pageRequestDTO);

	TodoDTO getOne(Long tno);
	void remove(Long tno);
	void modify(TodoDTO todoDTO);
	
}
```

ServiceImpl 에서는 getList()는 다음과 같이 구현한다.

```java
@Overrice
public PageResponseDTO<TodoDTO> getList(PageRequestDTO pageRequestDTO) {

	List<TodoVO> voList = todoMapper.selectList(pageRequestDTO);
	List<TodoDTO> dtoList = voList.stream()
				.map(vo -> modelMapper.map(vo, TodoDTO.class))
				.collect(Collectors.toList());

	int total = todoMapper.getCount(PageRequestDTO);

	PageResponseDTO<TodoDTO> pageResponseDTO = PageResponseDTO.<TodoDTO>withAll()
			.dtoList(dtoList)
			.total(total)
			.pageRequestDTO(pageRequestDTO)
			.build();

	return pageResponseDTO;
}
```

Service의 getList()는 테스트를 통해서 결과를 확인해 주도록 하자.
ServiceTests에서는 기존의 getAll()을 사용하는 부분은 삭제하고 새로운 테스트 코드를 작성하자.

```java
@Test
public void testPaging() {

	PageRequestDTO pageRequestDTO = PageRequestDTO._builder_().page(1).size(10).build();
	
	PageResponseDTO<TodoDTO> responseDTO = todoService.getList(pageRequestDTO);
	
	log.info(responseDTO);
	
	responseDTO.getDtoList().stream().forEach(todoDTO -> log.info(todoDTO));
	
	}
```

실행 결과에서 start / end / prev / next 등이 제대로 처리되었는지 확인해주자.

![스크린샷 2023-06-12 오후 4 31 18](https://github.com/ParkRio/MegaKGCoffee/assets/96435200/592fa127-e380-4400-9cc1-34956f7b2e1d)


## TodoController 와 JSP 처리

Controller의 list() 에서는 PageRequestDTO를 파라미터로 처리하고,
Model에 PageResponseDTO의 데이터들을 담을 수 있도록 변경하자.

```java
@RequestMapping("/list")
public void list(@Valid PageRequestDTO pageRequestDTO, BindingResult bindingResult, Model model) {

	log.info(pageRequestDTO);
	
	if(bindingResult.hasErrors()) {
	
	pageRequestDTO = pageRequestDTO.builder().build();
	
	}

	model.addAttribute("responseDTO", todoService.getList(pageRequestDTO));
}
```

Controller의 list() 는 @Valid를 이용해서 잘못된 파라미터 값들이 들어오는 경우 page는 1,
size는 10으로 고정된 값을 처리하도록 구성하자.

기존과 달리 Model에 'responseDTO'라는 이름으로 PageResponseDTO를 담아주었기 때문에
jsp에 받는 결과값이 있다면 수정을 해주어야 한다.

![스크린샷 2023-06-12 오후 4 44 52](https://github.com/ParkRio/MegaKGCoffee/assets/96435200/8a38cac4-6602-43ef-abb1-b7a3341b03d4)

![스크린샷 2023-06-12 오후 4 48 44](https://github.com/ParkRio/MegaKGCoffee/assets/96435200/9a1b6d28-0edd-446d-9e28-98b920cea905)

---

## 페이지 이동 확인

브라우저를 통해서 페이지의 이동에 문제가 없다는 것을 확인했다면 화면 아래쪽에 페이지 번호들을 출력하도록 구성하자.

페이지 번호는 부트스트랩의 pagenation 이라는 컴포넌트를 적용하겠다.

![스크린샷 2023-06-12 오후 5 28 33](https://github.com/ParkRio/MegaKGCoffee/assets/96435200/59b7814f-542c-4eb2-94a7-0a4bba061582)

## 페이지의 이벤트 처리

화면에서 페이지 번호를 누르면 이동하는 처리는 자바스크립트를 이용해서 처리해야 한다.
화면의 페이지 번호를 의미하는 < a > 태그에 직접 'onClick'을 적용할 수도 있지만,
한 번에 < ul > 태그에 이벤트를 이용해서 처리하도록 한다.

우선은 각 페이지 번호에 적절한 페이지 번호를 가지도록 구성하자.

이때는 'data-' 속성을 이용해서 필요한 속성을 추가해주는 방식이 좋다.

예제에서는 'data-num'이라는 속성을 추가해서 페이지 번호를 보관하도록 구성하자.
(바로 위 이미지와 같은 코드이다.)

그리고 script를 작성하자.


![스크린샷 2023-06-12 오후 5 43 35](https://github.com/ParkRio/MegaKGCoffee/assets/96435200/b5a1929b-fda8-45b0-b88a-af35409423e7)


자바스크립의 이벤트 처리는 < ul > 태그에 이벤트를 등록하고 < a > 태그를 클릭했을 때만 data-num 속성값을
읽어와서 현재 주소 (self.location)를 변경하는 방식으로 작성하자.

자바스크립트에서 백틱 (` `)을 이용하면 문자열 결합에 '+' 를 이용해야 하는 불편함을 줄일 수 있다.
대신에 JSP의 EL이 아니라는 것을 표시하기 위해서 '₩${}'로 처리해야만 한다.

자바스크립트 처리가 완료되면 화면상의 페이지 번호를 클릭해서 페이지 이동이 가능해진다.

---

## 조회 페이지로의 이동

목록 페이지는 특정한 Todo의 제목(title)을 눌러서 조회 페이지로 이동하는 기능이 존재한다.
기존에는 단순히 tno만을 전달해서 '/todo/read?tno=33' 과 같은 방식으로 이동했지만,
페이지 번호가 붙을 때는 page와 size 등을 같이 전달해 주어아만 조회 페이지에서 다시 목록으로
이동할 때 기존 페이지를 볼 수 있게 된다.

이를 위해 list.jsp 에는 각 Todo의 링크 처리 부분을 수정할 필요가 있다.
페이지 이동 정보는 PageRequestDTO 안에 있으므로 PageRequestDTO 내부에 간단한 메소드를
작성해서 필요한 링크를 생성할 때 사용한다.

파라미터로 전달되는 PageRequestDTO는 Model로 자동 전달되기 때문에 별도의 처리가 필요하지 않다.


![스크린샷 2023-06-12 오후 6 44 36](https://github.com/ParkRio/MegaKGCoffee/assets/96435200/63c21099-fb36-452f-830a-d1e26865bcb5)

PageRequestDTO 에는 'link'라는 속성을 추가하고 getLink()를 추가해서 GET 방식으로
페이지 이동에 필요한 링크들을 생성한다.

이를 list.jsp에서는 다음과 같이 사용한다.

![스크린샷 2023-06-12 오후 6 48 12](https://github.com/ParkRio/MegaKGCoffee/assets/96435200/03f37662-51c0-463a-bdbb-16393924852d)

예를 들어 4페이지에서 특정한 번호의 게시글을 클릭하면 'http://localhost:8080/todo/read?tno=1493&page=4&size=10' 와 같은 형태의 링크로 이동하게 된다.

## 조회에서 목록으로

조회 화면에서는 기존과 달리 PageRequestDTO를 추가로 이용하도록 Controller를 수정해야 한다.
Controller의 read() 메소드는 PageRequestDTO 파라미터를 추가해서 다음과 같이 수정한다.

![스크린샷 2023-06-12 오후 6 56 43](https://github.com/ParkRio/MegaKGCoffee/assets/96435200/8798ae11-e97a-4ca7-9b4f-7b994cf6a298)

리스트를 출력하는 jsp가 아니라 읽는 jsp에서는 예를 들면 read.jsp 에서는
'List' 버튼의 링크를 다시 처리해주어야 한다.

![스크린샷 2023-06-12 오후 7 08 57](https://github.com/ParkRio/MegaKGCoffee/assets/96435200/76fc4405-a111-4817-ba90-31209f1805d9)

브라우저는 특정한 페이지에서 조회 페이지로 이동해서 [List] 버튼을 눌렀을 때 정상적으로 이동하는지 확인한다.

---

## 조회에서 수정으로

조회 화면에서 수정 화면으로 이동할 때도 현재 페이지 정보를 유지해야 하기 때문에 
예) read.jsp 에서는 링크 처리 부분은 다음과 같이 만든다.

![스크린샷 2023-06-12 오후 7 26 00](https://github.com/ParkRio/MegaKGCoffee/assets/96435200/6b3e8d96-8c8a-4b12-a30f-27674f68c8b0)

---

## 수정 화면에서의 링크 처리

수정 화면에서도 다시 목록으로 가는 링크가 필요하다.
다행히도 Controller 의 read() 메소드는 GET 방식으로 동작하는 '/todo/modify' 에도 동일하게 처리되므로
JSP에서 PageRequestDTO를 사용할 수 있다.

예 ) modify.jsp 의 'List' 버튼을 누르는 자바스크립트의 이벤트 부분은 다음과 같이 만든다.

![스크린샷 2023-06-12 오후 7 30 16](https://github.com/ParkRio/MegaKGCoffee/assets/96435200/07898a0e-86a9-4aa9-95a0-aaa6af58dd80)

---

## 수정 / 삭제 처리 후 페이지 이동

실제 수정 / 삭제 작업은 POST 방식으로 처리되고 삭제 처리가 된 후에는 다시 목록으로 이동할 필요가 있다.
그렇기 때문에 수정 화면에서 < form > 태그로 데이터를 전송할 때 페이지와 관련된 정보를 같이 추가해서
전달해야만 한다.

![스크린샷 2023-06-12 오후 7 42 00](https://github.com/ParkRio/MegaKGCoffee/assets/96435200/e7ac69ef-d272-4c62-855e-490b2c9d7b01)

Controller 의 @PostMapping("/remove") 도 만들자

![스크린샷 2023-06-12 오후 7 43 26](https://github.com/ParkRio/MegaKGCoffee/assets/96435200/301abbc3-ed16-4cfe-8090-15516db5ab8f)

---

## 수정 처리 후 이동

Todo를 수정한 후에 목록으로 이동할 때는 페이지 정보를 이용해야 하므로
Controller의 modify() 에서는 PageRequestDTO를 받아서 처리하도록 변경한다.

![스크린샷 2023-06-13 오전 11 14 06](https://github.com/ParkRio/MegaKGCoffee/assets/96435200/5274a1a2-076d-4617-b173-1cb9f5770c53)
