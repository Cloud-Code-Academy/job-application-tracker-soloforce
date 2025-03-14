public with sharing class DummyJSONCalloutMockGenerator implements HttpCalloutMock {
    public static String DUMMY_JOB_PAYLOAD = '{"totalCount": 11,"jobs": [{"title": "Senior Software Engineer - Onsite","location": "Miami, FL","snippet": "We are seeking a talented and experienced Full Stack & Blockchain <b>Developers </b>to join our dynamic team.","salary": "$500k - $700k","source": "works-hub.com","type": "Full-time","link": "https://jooble.org/desc/2652691703042950134?ckey=Salesforce+Developer&rgn=9649&pos=5&groupId=40906&elckey=9149697001363150523&p=1&aq=1871843965934284546&cid=4528&jobAge=4203&brelb=10&bscr=8.741174&scr=8.741174","company": "LeverX","updated": "2024-09-20T04:31:54.5400000","id": 2652691703042950134}]}';


	public HTTPResponse respond(HTTPRequest req) {
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');

		if (req.getMethod() == 'POST') {
			res.setBody('{"status": "success"}');
            res.setBody(DUMMY_JOB_PAYLOAD);
		}
		res.setStatusCode(200);
		return res;
	}
}