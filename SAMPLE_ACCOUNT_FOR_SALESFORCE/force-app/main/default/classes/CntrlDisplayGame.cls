/**
 * @description 생성자
 */
public class CntrlDisplayGame {
	
	public CntrlDisplayGame(){
		searchGameInfo();   // 현재 등록되어있는 게임 정보 검색(SELECT)
		// createGameInfo(); 	// 새로운 게임 정보를 추가(INSERT)
	    // updateGameInfo();   // 게임 정보 수정(UPDATE)
		deleteGameInfo();   // 게임 정보 삭제(DELETE)
		upsertGameInfo();   // 게임 정보 추가 및 수정
	}

/**
 * @description 게임 정보 검색(select)
 */ 
	public void searchGameInfo(){
		
		List<Game__c> gameList = [SELECT Id, Name, Genrel__c, ReleaseDate__c, ProductionCompany__c FROM Game__c];

		System.debug('==================SELECT 결과_START ======================');
		System.debug('SELECT 결과수:' + gameList.size());
		for(Game__c game:gameList){
			
			System.debug('---------------------------------------------');
			System.debug('게임 타이틀:' + game.Name);
			System.debug('게임 장르:' + game.Genrel__c);
			System.debug('게임 출시일:' + game.ReleaseDate__c);
			System.debug('게임 제작사:' + game.ProductionCompany__c);
		}
			System.debug('=================SELECT 결과_END ==========================');
	}

/**
 * @description 게임 정보 등록(Insert)
 */
    public void createGameInfo(){
        
        Game__c newGame = new Game__c();
        newGame.Name = 'StarCraft';  // 게임명
        newGame.Genrel__c = 'RTS'; 	 // 게임 장르
        newGame.ReleaseDate__c = Date.newInstance(2020,11,30); // 게임 출시일
        newGame.ProductionCompany__c = 'Blizzard';   // 게임 제작사
        
        // 게임 정보 등록(Insert)
        insert newGame;
        
        List<Game__c> validGameList = [SELECT Id, Name, Genrel__c, ReleaseDate__c, ProductionCompany__c FROM Game__c];
        System.debug('==============Insert 결과_START');
        System.debug('SELECT 결과수 : ' + validGameList.size());
        for(Game__c game:validGameList){
            
            System.debug('----------------------------------------');
            System.debug('게임 타이틀: ' + game.Name);
            System.debug('게임 장르 : ' + game.Genrel__c);
            System.debug('게임 출시일: '	+ game.ReleaseDate__c);
            System.debug('게임 제작사: ' + game.ProductionCompany__c);
        }
        
        System.debug('================= INSERT 결과_END');
    }
    
/**
 * @description 게임 정보 수정(update)
 */
    public void updateGameInfo(){
        
        List<Game__c> gameList = [SELECT Id, Name, Genrel__c, ReleaseDate__c, ProductionCompany__c FROM Game__c];
        
        // 새로 추가한 Starcraft 정보 수정
        // Index를 알고 있는 경우
        // Game__c editGame = gameList.get(3);
        // Game__c editGame = gameList[3];
        
        Game__c editGame;
        
        for(Game__c game:gameList){
            // SELECT한 게임 정보의 리스트를 루프
             
            // if(game.Name.equals('StarCraft')) {   // equals 대소문자 구분
              
            if(game.Name.equals('StarCraft')) {   // equalsIgnoreCase : 대소문자 구분 X
                // 게임 이름이 'StarCraft' 인 게임 정보 레코드를 습득
				editGame = game;
                break;
                
            }
        }
        
        System.debug('==============UPDATE 결과_START ===============');
        	System.debug('UPDATE 이전 출시일 : ' + editGame.ReleaseDate__c);
        
        // 수정할 게임의 출시일을 수정
        editGame.ReleaseDate__c = Date.newInstance(1998,11,30);
        
        // 게임 정보 등록
        update editGame;
        
        // 게임명이 'StarCraft' 인 레코드를 SELECT(SOQL 에서는 대소문자 구분X)
        List<Game__c> validGame = [SELECT Id, ReleaseDate__c FROM Game__c WHERE Name = 'StarCraft'];
        
        System.debug('UPDATE 이후 출시일 :' + validGame.get(0).ReleaseDate__c);
        System.debug('====================== UPDATE END =========================');
          
    }
    
     /**
 	 * @description 게임 삭제(delete)
 	 */
    public void deleteGameInfo() {

        List<Game__c> gameList = [SELECT Id, Name, Genrel__c, ReleaseDate__c, ProductionCompany__c FROM Game__c];

        // 새로 추가한 StarCraft 게임 정보 삭제
        Game__c delGame;

        for (Game__c game : gameList) {
            // SELECT한 게임 정보의 리스트를 루프

            if (game.Name.equalsIgnoreCase('StarCraft')) {		// equalsIgnoreCase : 대소문자 구분 X
                // 게임이름이 "StarCraft" 인 게임 정보 레코드를 습득

                delGame = game;
                break;
            }
        }

        delete delGame;


        // 게임명이 "StarCraft"인 레코드를 SELECT(SOQL에서는 대소문자 구분 X)
        List<Game__c> validGame = [SELECT Id, ReleaseDate__c FROM Game__c WHERE Name = 'StarCraft'];        
        System.debug('=================== DELETE 결과_START ==================');
        System.debug('게임 이름이 StarCraft인 레코드 SELECT 결과 : ' + validGame.size());
        System.debug('=================== DELETE 결과_END ====================');
    }
    
   	/**
   	 * @description 게임 정보 추가 및 수정(upsert)
   	 */
    public void upsertGameInfo(){
        // 게임 개체에 등록되어 있는 레코드를 SELECT
        List<Game__c> gameList = [SELECT Id, Name, Genrel__c, ReleaseDate__c, ProductionCompany__c FROM Game__c];
        
        // 신규 추가용 게임 정보 정의
        Game__c newGame = new Game__c(
        	Name = 'OverWatch',
        	Genrel__c = 'FPS',
        	ReleaseDate__c = Date.newInstance(2016,5,24),
        	ProductionCompany__c = 'Blizzard'
            );
        
        System.debug('=============== UPSERT 이전_START ================');
        System.debug('SELECT 결과수 : ' + gameList.size());
        for(Game__c game:gameList) {
            System.debug('----------------------------------------------------');
            System.debug('게임 타이틀 : ' + game.Name);
            System.debug('게임 장르 : ' + game.Genrel__c);
            System.debug('게임 출시일 : ' + game.ReleaseDate__c);
            System.debug('게임 제작사 : ' + game.ProductionCompany__c);
        }
        System.debug('=================== UPSERT 이전_END ===============');
    
    
    // SELECT 로 얻어온 게임 정보 리스트의 첫 번째 레코드의 제작사를 변경
    gameList.get(0).ProductionCompany__c = '펍지';
    
    // upsert 대상 리스트에 신규 추가용 게임 정보를 추가
    gameList.add(newGame);
    
    // 게임 정보 리스트를 UPSERT
    upsert gameList;
    
    // 게임 개체에 등록되어 있는 레코드를 SELECT
    List<Game__c> validGameList = [SELECT Id, Name, Genrel__c, ReleaseDate__c, ProductionCompany__c FROM Game__c];
    	
        System.debug('=================== UPSERT 이후_START ==================');
        System.debug('SELECT 결과수 : ' + validGameList.size());
        for (Game__c game : validGameList) {

            System.debug('----------------------------------------------------');
            System.debug('게임 타이틀 : ' + game.Name);
            System.debug('게임 장르 : ' + game.Genrel__c);
            System.debug('게임 출시일 : ' + game.ReleaseDate__c);
            System.debug('게임 제작사 : ' + game.ProductionCompany__c);
        }
    	System.debug('============== UPSERT 이후_END ==============');
	}
}