import { combineReducers } from 'redux';
import { CHANGE_QUESTION , QUESTION_ANSWER , SUBMIT , FETCH, START, submi} from './actions'


function score(state = 0, action = {}){
	switch(action.type) {
		case SUBMIT:
			state = 0
			for (var i = action.payload.questions.length - 1; i >= 0; i--) {
				if(action.payload.questions[i].answer === action.payload.questions[i].userAnswer){
					state += 1
				}
			}
			return state
		case 'FETCH_STATE_SUCCESS':
			state = 0
			return state;
		case START:
			state = 0
			return state;
		default:
			return state;
	}
}
function finished(state = false, action = {}){
	switch(action.type){
		case SUBMIT:
			state=true;
			return state
		case 'FETCH_STATE_SUCCESS':
			state = false
			return state;
		case START:
			state = false
			return state;
		case 'FINISH':
			state = true;
			return state;
		default:
			return state; 
	}
}

function currentQuestion(state = 0, action = {}){
	switch(action.type) {
		case CHANGE_QUESTION:
		if(action.payload.plusorminus === 0){
			if(state >=1){
				state -= 1
				return state
			}
			else{
				return state
			}
		}
		if (action.payload.plusorminus === 1) {
			if(state <= 8){
				state += 1
				return state
			}
		else{
			return state
		}
		}
		return  state
		case 'FETCH_STATE_SUCCESS':
			state = 0
			return state;
		case START:
			state = 0
			return state;
		default:
		return state;
	}
}

function questions(state = [], action = {}){
	switch(action.type) {
		case QUESTION_ANSWER: 
		return state.map((question,i) => {
			return { ...question,
					userAnswer: action.payload.index === i ? action.payload.answer : question.userAnswer}
		})
		case 'FETCH_STATE_SUCCESS':
			state = action.json;
			return state;
		default:
		return state;
	}
}

function timer(state = 60, action = {}){
	switch(action.type){
		case START:
			state = 60;
			return state
		case 'COUNTER':
			state = state -1;
			return state;

		default:
			return state;
	}
}

function fetch(state=FETCH, action){
	let newState;
	switch (action.type){
		case 'FETCH_STATE_BEGIN':
			newState = JSON.parse(JSON.stringify(state));
			newState.fetching = true;
			return newState;
		case 'FETCH_STATE_SUCCESS':
			newState = JSON.parse(JSON.stringify(state));
			newState.fetching = false
			newState.finished = true;
			return newState;
		case 'FETCH_STATE_FAILURE':
			newState = JSON.parse(JSON.stringify(state));
			newState.fetching = false;
			newState.error = action.error
			return newState;

		default:
			return state;
	}
}
const GlobalState = (combineReducers({
	score,
	finished,
	currentQuestion,
	questions,
	fetch,
	timer

}));

export default GlobalState;