<?php
use PHPUnit\Framework\TestCase;
use Demo\File51;

class File51Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File51::add(2, 3));
    }
}
