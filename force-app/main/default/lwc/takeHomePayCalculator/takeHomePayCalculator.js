import {LightningElement, wire, api, track} from 'lwc';
import {getRecord} from 'lightning/uiRecordApi';
import SALARY from '@salesforce/schema/JobApplication__c.Salary__c';

const medicareLevyAndSurchargeRate = 0.02;
const notTaxedIncome = 18200;
const secondIncomeBracket = 45000;
const thirdIncomeBracket = 135000;
const fourthIncomeBracket = 190000;
const fullTaxForSecondBracket = 4288;
const fullTaxForThirdBracket = 31288;
const fullTaxForForthBracket = 51638;
const secondIncomeBracketRate = 0.16;
const thirdIncomeBracketRate = 0.3;
const fourthIncomeBracketRate = 0.37;
const fifthIncomeBracketRate = 0.45;
const monthsInYear = 12;
const weeksInYear = 52.01;


const FIELDS = ["JobApplication__r.Salary__c"];

export default class WiredTakeHomePayCalculator extends LightningElement {
    mediCareAmount=0;
    incomeTaxPayable=0;
    annualTakeHomePay=0;
    monthlyTakeHomePay=0;
    weeklyTakeHomePay=0;
    @api recordId;
    @track inputSalary;
    initialValueLoaded = false;
    @wire(getRecord, {recordId: "$recordId", fields: [SALARY]})
    jobApplication({error, data}){
        if(data && !this.initialValueLoaded){
            this.inputSalary = data.fields.Salary__c.value;
            this.initialValueLoaded = true;
            this.calculateTaxesAndFinalSalary();
        }
    }
    handleInputChange(event){
        this.inputSalary = event.target.value;
        this.calculateTaxesAndFinalSalary();
    }
    calculateTaxesAndFinalSalary(){
        this.mediCareAmount = this.inputSalary * medicareLevyAndSurchargeRate;
        if(this.inputSalary <= notTaxedIncome){
            this.incomeTaxPayable = 0;
        } else if(this.inputSalary <= secondIncomeBracket){
            this.incomeTaxPayable = (this.inputSalary - notTaxedIncome) * secondIncomeBracketRate;
        } else if(this.inputSalary <= thirdIncomeBracket){
            this.incomeTaxPayable = fullTaxForSecondBracket + (this.inputSalary - secondIncomeBracket) * thirdIncomeBracketRate;
        } else if(this.inputSalary <= fourthIncomeBracket){
            this.incomeTaxPayable = fullTaxForThirdBracket + (this.inputSalary - thirdIncomeBracket) * fourthIncomeBracketRate;
        } else {
            this.incomeTaxPayable = fullTaxForForthBracket + (this.inputSalary - fourthIncomeBracket) * fifthIncomeBracketRate;
        }
        this.annualTakeHomePay = this.inputSalary - (this.incomeTaxPayable + this.mediCareAmount);
        this.monthlyTakeHomePay = this.annualTakeHomePay/monthsInYear;
        this.weeklyTakeHomePay = this.annualTakeHomePay/weeksInYear;
    }
    
}