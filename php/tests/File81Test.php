<?php
use PHPUnit\Framework\TestCase;
use Demo\File81;

class File81Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File81::add(2, 3));
    }
}
