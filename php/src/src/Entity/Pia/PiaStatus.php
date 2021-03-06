<?php

/*
 * Copyright (C) 2015-2018 Libre Informatique
 *
 * This file is licensed under the GNU LGPL v3.
 * For the full copyright and license information, please view the LICENSE.md
 * file that was distributed with this source code.
 */

namespace PiaApi\Entity\Pia;

class PiaStatus extends AbstractStatus
{
    public const IN_PROGRESS = 0;
    public const REFUSED = 1;
    public const SIMPLE_VALIDATION = 2;
    public const SIGNED_VALIDATION = 3;
    public const ARCHIVED = 4;
    public const WAITING_FOR_VALIDATION = 5;

    protected static $statusNames = [
        self::IN_PROGRESS             => 'IN_PROGRESS',
        self::REFUSED                 => 'REFUSED',
        self::SIMPLE_VALIDATION       => 'SIMPLE_VALIDATION',
        self::SIGNED_VALIDATION       => 'SIGNED_VALIDATION',
        self::ARCHIVED                => 'ARCHIVED',
        self::WAITING_FOR_VALIDATION  => 'WAITING_FOR_VALIDATION',
    ];
}
