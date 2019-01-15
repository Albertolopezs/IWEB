export const QUESTION_ANSWER = 'QUESTION_ANSWER';
export const CHANGE_QUESTION = 'CHANGE_QUESTION';
export const SUBMIT = 'SUBMIT';
export const START = 'START';
export const FETCH = {
	fetching: false,
	finished: false,
	error: null
}
export const API = 'https://quiz2019.herokuapp.com/api/quizzes/random10wa?token=67b100496ccef9b63860';

export function questionAnswer(index, answer) {
	return { type: QUESTION_ANSWER, payload: { index, answer } };

}

export function changeQuestion(plusorminus) {
	return { type: CHANGE_QUESTION, payload: {plusorminus} };
}

export function submit(questions){
	return { type: SUBMIT, payload:{questions}}
}

export function start(){
	return { type: START }
}

export function reduce_counter(){
	return { type: 'COUNTER'}
}

export function finish(){
	return {type: 'FINISH'}
}

export function load_Data(questions){
	return {type: 'LOAD_DATA', payload:{questions}}
}

//Get data

export function fetchStateBegin(){
	return {type: 'FETCH_STATE_BEGIN' }
}

export function fetchStateSuccess(json_received){
	return{
		type: 'FETCH_STATE_SUCCESS',
		json: json_received
	}
}

export function fetchStateFailure(error){
	return{
		type: 'FETCH_STATE_FAILURE',
		error: error
	}
}

export function handleErrors(response){
	if(!response.ok){
		console.log("Error: " + response.statusText);
		throw Error(response.statusText);
	}
	return response
}

export function fetchState(){
	return dispatch => {
		dispatch(fetchStateBegin());
		return fetch(API)
			.then(handleErrors)
			.then(res => res.json())
			.then(json =>{
				return dispatch(fetchStateSuccess(json));
			})
			.catch(error=>{
				console.log(error);
				return dispatch(fetchStateFailure);
			})
	}
}
