import sys, os
import pandas as pd
from pandas import DataFrame


def report_grades( student, gradebk ):
    '''
    ######### DESCRIPTION ###########
    Get given student's class data
    and create .txt file with e-mail
    message content with grades.
    
    ######### ARGUMENTS #############
    student - (String) Name of the
    student, formatted 'Last, First'.
    '''
    
    # Get student's class data
    student_data = gradebk.loc[gradebk['Name'] == student]
    student_email = student_data.iloc[0][1]
    try:
        student_track = int(student_data['Track'])
    except:
        student_track = 0
    
    
    # Get track message for student
    if student_track in [50, 112]:
        if student_track == 50:
            track_msg = 'Your confirmed track assignment is Math/STS ' + str(student_track) + '.'
        elif student_track == 112:
            track_msg = 'Your confirmed track assignment is Math ' + str(student_track) + '.'
    else:
        track_msg = 'We do not yet have a confirmed track for you. To confirm your track, please submit a survey response on the course website.'
    
    
    # Get assignment grades' messages for student
    
    # Problem sets' grades
    hw_msg = range(len(filter(lambda x: 'HW' in x, student_data.columns.values)))
    for i in xrange(len(hw_msg)):
        score = str(student_data['HW' + str(i + 1)].iloc[0])
        score = str.strip(score)
        hw_msg[i] = 'For problem set #' + str(i + 1) + ', you earned a score of: ' + score + '.'
    
    # Reading responses' grades
    rr_msg = range(len(filter(lambda y: 'RR' in y, student_data.columns.values)))
    for i in xrange(len(rr_msg)):
        score = str(student_data['RR' + str(i + 1)].iloc[0])
        score = str.strip(score)
        rr_msg[i] = 'For reading response #' + str(i + 1) + ', you earned a score of: ' + score + '.'

    
    ########### Create e-mail message for student ###########
    
    # Standard messages
    greeting = 'Hello, History of Mathematics Student!'
    gen_info = 'The following is a report of the grades currently recorded for your problem sets and reading responses. Please report any errors to Professor ***** or your TA *****. Thank you!'
    error_msg = 'If you have dropped the course or believe you have received this message in error, please send an e-mail to ***** at *****. Thank you.'
    
    body = greeting + '\n\n' + gen_info + '\n\n' + str(track_msg) + '\n\n' + "\n".join(str(x) for x in hw_msg) + "\n\n" + "\n".join(str(y) for y in rr_msg) + '\n\n' + error_msg
    
    # Export student's message to text file (Filename 'Email-ID.txt')
    file = open('histMath_grade_emails\\' + student_email + '.txt', 'w')
    file.write(body)
    file.close()
            
    return


def generate_reports():
    '''
    ######### DESCRIPTION ###########
    Create .txt files for students'
    e-mail messages regarding grades.
    
    ######### ARGUMENTS #############
    gradebk - (DataFrame) Gradebook.
    '''
    
    # Load class gradebook
    os.chdir('C:\\Users\\Jacqueline\\Desktop')
    gradebk = pd.read_csv(os.getcwd() + '\\histMath_gradebook.csv')
    
    # Get list of students with unconfirmed tracks
    # unknown_track = gradebk.loc[~gradebk['Track'].isin([50, 112])]
    
    class_roster = gradebk['Name']
    for i in xrange(len(class_roster)):
        report_grades(class_roster.iloc[i], gradebk)
    return


def main(argv):
    generate_reports()
    return


if __name__ == "__main__":
   main(sys.argv[1:])
