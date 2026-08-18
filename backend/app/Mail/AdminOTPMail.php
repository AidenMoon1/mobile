<?php

namespace App\Mail;

use Illuminate\Mail\Mailable;

class AdminOTPMail extends Mailable
{
    public $otp;
    public $title;
    public $messageBody;

    public function __construct($otp, $title = 'Verifikasi Administrator', $messageBody = 'Silakan gunakan kode OTP di bawah ini untuk memverifikasi identitas Anda.')
    {
        $this->otp = $otp;
        $this->title = $title;
        $this->messageBody = $messageBody;
    }

    public function build()
    {
        return $this
            ->from(config('mail.from.address'), config('mail.from.name'))
            ->subject($this->title . ' - Sukabumi One Access')
            ->view('emails.admin-otp')
            ->with([
                'otp' => $this->otp,
                'title' => $this->title,
                'messageBody' => $this->messageBody,
            ])
            ->priority(1); // 1 = High, 3 = Normal, 5 = Low
    }
}
